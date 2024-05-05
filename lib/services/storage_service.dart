import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadAvatar({
    required File file,
    required String uid,
  }) async {
    try {
      //create a reference to the location you want to upload to in Firebase storage
      Reference fileRef = _firebaseStorage
          .ref('users/avatar')
          .child('$uid${path.extension(file.path)}');
      //upload file to firebase storage
      UploadTask uploadTask = fileRef.putFile(file);
      //get the download URL once the download is complete
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      //return downloadURL
      return downloadURL;
    } catch (e) {
      log("Error uploading file $e");
    }
    return null;
  }

  // Future<String?> uploadAvatar({
  //   required File file,
  //   required String uid,
  // }) async {
  //   // Create a reference to the location you want to upload to in Firebase Storage
  //   Reference fileRef = _firebaseStorage
  //       .ref('users/avatar')
  //       .child('$uid${path.extension(file.path)}');
  //   // Upload the file to Firebase Storage
  //   UploadTask task = fileRef.putFile(file);
  //   return task.then((p0) {
  //     if (p0.state == TaskState.success) {
  //       return fileRef.getDownloadURL();
  //     }
  //     return null;
  //   });
  // }
}
