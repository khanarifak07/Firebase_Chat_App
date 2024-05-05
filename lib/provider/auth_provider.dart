import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/screens/auth/login_page.dart';
import 'package:firebase_chat_app/screens/homepage/homepage.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:firebase_chat_app/services/storage_service.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final authProvider = ChangeNotifierProvider((ref) => AuthProvider());

class AuthProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  final auth = AuthService();
  final storage = StorageService();
  //avatar var
  File? avatar;
  //pick avatar method
  Future<void> pickAvatar() async {
    var pickedAvatar =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedAvatar != null) {
      avatar = File(pickedAvatar.path);
      notifyListeners();
    }
  }

  void registerUser(BuildContext context) async {
    //set loading as true
    isLoading = true;
    notifyListeners();
    try {
      //check for fields
      if (nameController.text.isEmpty &&
          emailController.text.isEmpty &&
          passwordController.text.isEmpty &&
          confirmPasswordController.text.isEmpty) {
        showSnackBar(context, "Please fill the details", Colors.red);
      } else {
        if (passwordController.text == confirmPasswordController.text) {
          if (avatar != null) {
            //Password match register user
            String? errorMessage = await auth.signUpWithEmailAndPassword(
                emailController.text, passwordController.text);
            //check for error message
            if (errorMessage != null) {
              showSnackBar(context, errorMessage, Colors.red);
              isLoading = false;
              notifyListeners();
            }
            //upload file and get the download url
            String? downloadURL = await storage.uploadAvatar(
                file: avatar!, uid: FirebaseAuth.instance.currentUser!.uid);
            //check for download URL
            if (downloadURL != null) {
              // File uploaded successfully, use downloadURL
              log('File uploaded. Download URL: $downloadURL');
            } else {
              // Error occurred while uploading file
              log('Failed to upload file.');
            }
            //upload user detials in firebase
            await FirebaseFirestore.instance
                .collection("usersData")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set({
              'name': nameController.text,
              'email': emailController.text,
              'avatar': downloadURL,
            });
            //show snackbar
            showSnackBar(context, "User registered successfully", Colors.green);
            navigateToScreen(context, const HomePage());
          } else {
            showSnackBar(context, "Avatar required", Colors.red);
          }
        } else {
          showSnackBar(context, "Password Mismatch", Colors.red);
        }
      }
    } catch (e) {
      log('Error while creating user $e');
    }
    //set loading as false
    isLoading = false;
    notifyListeners();
  }

  //register user
  // void registerUser(BuildContext context) async {
  //   isLoading = true;
  //   notifyListeners();

  //   if (passwordController.text == confirmPasswordController.text) {
  //     if (emailController.text.isNotEmpty &&
  //         passwordController.text.isNotEmpty &&
  //         avatar != null) {
  //       String? errorMessage = await auth.signUpWithEmailAndPassword(
  //         emailController.text,
  //         passwordController.text,
  //       );

  //       if (errorMessage != null) {
  //         // Show Snackbar with error message
  //         showSnackBar(context, errorMessage, Colors.red);
  //       } else {
  //         //upload the image and get the download URL
  //         String? downloadURL = await storage.uploadAvatar(
  //           file: avatar!,
  //           uid: FirebaseAuth.instance.currentUser!.uid,
  //         );
  //         //check if download success
  //         if (downloadURL != null) {
  //           // File uploaded successfully, use downloadURL
  //           log('File uploaded. Download URL: $downloadURL');

  //         } else {
  //           // Error occurred while uploading file
  //           log('Failed to upload file.');
  //         }

  //         showSnackBar(context, "User registered successfully", Colors.green);
  //         navigateToScreen(context, const LoginPage());
  //       }
  //     } else {
  //       showSnackBar(context, 'Please enter email and password', Colors.red);
  //     }
  //   } else {
  //     showSnackBar(context, 'Password Mismatch', Colors.red);
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

  //login user
  void loginUser(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      String? errorMessage = await auth.loginWithEmailAndPassword(
          emailController.text, passwordController.text);

      if (errorMessage != null) {
        // Show Snackbar with error message
        showSnackBar(context, errorMessage, Colors.red);
      }
    } else if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showSnackBar(context, 'Please enter email and password', Colors.red);
    } else {
      showSnackBar(context, 'Something went wrong', Colors.red);
    }
    isLoading = false;
    notifyListeners();
  }

  //logout
  void logout(BuildContext context) async {
    await auth.signOutUser();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    navigateToScreen(context, const LoginPage());
  }
}
