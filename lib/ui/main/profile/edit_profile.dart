import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../../../api/api_wrapper.dart';
import '../../../auth/authentication.dart';
import '../../../utils/trppit_color.dart';

class EditProfileScreen extends StatefulWidget {
  static const PAGE_NAME = 'edit_profile_screen';

  static final int INDEX = 0;
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String? firstNameError = null;
  String? phoneNumberError = null;
  String? bloodGroupError = null;
  String? emailError = null;
  bool isInProgress = false;
  File? selectedImageFile = null;
  @override
  void initState() {
    updateUi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(right: 10, left: 10),
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top + 50),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: [
                      _getProfileIconCircle(),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading:
                                            new Icon(Icons.camera_alt_rounded),
                                        title: new Text('Camera'),
                                        onTap: () async {
                                          pickImage(ImageSource.camera);
                                        },
                                      ),
                                      ListTile(
                                        leading: new Icon(Icons.image),
                                        title: new Text('Gallery'),
                                        onTap: () {
                                          pickImage(ImageSource.gallery);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Card(
                            color: accent_color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getEditText(
                      firstNameController,
                      'First Name',
                      'Enter First Name',
                      width: MediaQuery.of(context).size.width * 0.45,
                      errorMessage: firstNameError,
                    ),
                    getEditText(
                      lastNameController,
                      'Last Name',
                      'Enter Last Name',
                      width: MediaQuery.of(context).size.width * 0.45,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                getEditText(
                  emailController,
                  'Email',
                  'Enter Email',
                  errorMessage: emailError,
                ),
                const SizedBox(
                  height: 10,
                ),
                getEditText(
                  phoneNumberController,
                  'Phone number',
                  'Enter Phone Number',
                  errorMessage: phoneNumberError,
                ),
                const SizedBox(
                  height: 10,
                ),
                getEditText(
                  bloodGroupController,
                  'Blood Group in case of emergency',
                  'Enter Blood Group',
                  errorMessage: bloodGroupError,
                ),
                const SizedBox(
                  height: 10,
                ),
                getEditText(
                  bioController,
                  'Bio',
                  'Tell me about yourself',
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ),
        titleBar(context, 'My Profile', rightItem: SizedBox()),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: accent_color, // Background color
              ),
              onPressed: () async {
                firstNameError = '';
                phoneNumberError = '';
                bloodGroupError = '';
                emailError = '';
                if (firstNameController.text.isEmpty) {
                  firstNameError = 'This field cannot be empty';
                }
                if (phoneNumberController.text.isEmpty) {
                  phoneNumberError = 'This field cannot be empty';
                }
                if (emailController.text.isEmpty) {
                  emailError = 'This field cannot be empty';
                }
                if (bloodGroupController.text.isEmpty) {
                  bloodGroupError = 'This field cannot be empty';
                }
                if (firstNameError == null ||
                    firstNameError!.isNotEmpty ||
                    phoneNumberError == null ||
                    phoneNumberError!.isNotEmpty ||
                    emailError == null ||
                    emailError!.isNotEmpty ||
                    bloodGroupError == null ||
                    bloodGroupError!.isNotEmpty) {
                  setState(() {});
                  showSnackBar(context, 'Please Resolve the Errors');
                  return;
                }
                setState(() {
                  isInProgress = true;
                });
                FocusScope.of(context).unfocus();
                var isSuccess = await updateProfile(
                    firstNameController.text,
                    lastNameController.text,
                    phoneNumberController.text,
                    bloodGroupController.text,
                    bioController.text,
                    email: emailController.text,
                    uploadFile: selectedImageFile?.path);
                if (isSuccess) {
                  updateUi();
                  showSnackBarApiSuccess(context);
                } else {
                  showSnackBarApiError(context);
                }
                setState(() {
                  isInProgress = false;
                });
              },
              child: Text("Save"),
            ),
          ),
        ),
        showProgress(isInProgress),
      ]),
    );
  }

  _getProfileIconCircle() {
    if ((Authentication.loggedInUser!.imageUri != null &&
            Authentication.loggedInUser!.imageUri!.isNotEmpty ||
        selectedImageFile != null)) {
      ImageProvider? image;
      if (selectedImageFile == null) {
        image = NetworkImage(Authentication.loggedInUser!.imageUri!);
      } else {
        image = FileImage(selectedImageFile!);
      }
      return Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: accent_color,
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
          border: Border.all(
            color: accent_color,
            width: 4.0,
          ),
        ),
      );
    } else {
      return Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.fill,
            child: Icon(Icons.person),
          ),
        ),
      );
    }
  }

  Widget getEditText(
    TextEditingController controller,
    String label,
    String hint, {
    errorMessage = null,
    width,
    keyboardType = TextInputType.text,
    maxLines = 1,
  }) {
    return Container(
      color: accent_color_light_bg,
      width: width,
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 12.0,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
            hintText: hint,
            alignLabelWithHint: true,
            errorText:
                errorMessage != null && errorMessage.toString().isNotEmpty
                    ? errorMessage
                    : null),
      ),
    );
  }

  void updateUi() {
    firstNameController.text = Authentication.loggedInUser!.firstName!;
    lastNameController.text = Authentication.loggedInUser!.lastName!;
    phoneNumberController.text = Authentication.loggedInUser!.phoneNumber!;
    bloodGroupController.text = Authentication.loggedInUser!.bloodGroup!;
    bioController.text = Authentication.loggedInUser!.bio!;
    if (Authentication.loggedInUser!.email != null) {
      emailController.text = Authentication.loggedInUser!.email!;
    }
  }

  void pickImage(ImageSource camera) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.selectedImageFile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    Navigator.pop(context);
  }
}
