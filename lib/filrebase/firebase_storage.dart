import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tripzie/auth/authentication.dart';

final storageRef = FirebaseStorage.instance.ref();

enum FirebaseFileType { profile_pic, post }

Future<String> firebaseProfileUpload(File file) async {
  return await firebaseUpload(file, storageRef);
}

Future<String> firebaseUpload(File file, Reference reference) async {
  try {
    String fileName =
        Authentication.loggedInUser!.userId! + "_" + file.path.split('/').last;
    print('uploading file to firebase storage: $fileName');
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final uploadFile = reference.child("images/profile/$fileName");
    var uploadTask = await uploadFile.putFile(file, metadata);
    var downloadUrl = await uploadFile.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  } on FirebaseException catch (e) {
    print("exception: $e");
    // ...
  }
  return Future.value(null);
}
