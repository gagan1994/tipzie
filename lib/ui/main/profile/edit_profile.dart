import 'package:flutter/material.dart';
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
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String? firstNameError = null;
  String? lastNameError = null;
  String? phoneNumberError = null;
  String? bloodGroupError = null;
  bool isInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top + 15,
                right: 10,
                left: 10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text("Edit Profile"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: _getProfileIconCircle(),
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
                      errorMessage: lastNameError,
                    ),
                  ],
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
        Material(
          elevation: 2,
          child: Container(
            color: Colors.white,
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top + 5,
              right: 10,
              left: 10,
            ),
            margin: EdgeInsets.only(bottom: 10),
            child: Text("Edit Text"),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Container(
            child: ElevatedButton(
              onPressed: () async {
                firstNameError = '';
                lastNameError = '';
                phoneNumberError = '';
                bloodGroupError = '';
                if (firstNameController.text.isEmpty) {
                  firstNameError = 'This field cannot be empty';
                }
                if (lastNameController.text.isEmpty) {
                  lastNameError = 'This field cannot be empty';
                }
                if (phoneNumberController.text.isEmpty) {
                  phoneNumberError = 'This field cannot be empty';
                }
                if (bloodGroupController.text.isEmpty) {
                  bloodGroupError = 'This field cannot be empty';
                }
                if (firstNameError == null ||
                    firstNameError!.isNotEmpty ||
                    lastNameError == null ||
                    lastNameError!.isNotEmpty ||
                    phoneNumberError == null ||
                    phoneNumberError!.isNotEmpty ||
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
                    bioController.text);
                if (isSuccess) {
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
    if (Authentication.getUser().photoURL != null &&
        Authentication.getUser().photoURL!.isNotEmpty) {
      return Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: accent_color,
          image: DecorationImage(
            image: NetworkImage(Authentication.getImageUri()),
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
}
