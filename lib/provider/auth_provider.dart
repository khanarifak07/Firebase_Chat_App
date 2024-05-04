import 'package:firebase_chat_app/screens/auth/login_page.dart';
import 'package:firebase_chat_app/services/auth/auth_service.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider((ref) => AuthProvider());

class AuthProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  final auth = AuthService();

  //register user
  void registerUser(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    if (passwordController.text == confirmPasswordController.text) {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        String? errorMessage = await auth.signUpWithEmailAndPassword(
            emailController.text, passwordController.text);

        if (errorMessage != null) {
          // Show Snackbar with error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('user registered successfully'),
              backgroundColor: Colors.green,
            ),
          );
          navigateToScreen(context, const LoginPage());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter email and password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password Mismatch'),
          backgroundColor: Colors.red,
        ),
      );
    }
    isLoading = false;
    notifyListeners();
  }

  //login user
  void loginUser(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      String? errorMessage = await auth.loginWithEmailAndPassword(
          emailController.text, passwordController.text);

      if (errorMessage != null) {
        // Show Snackbar with error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
    isLoading = false;
    notifyListeners();
  }

  //logout
  void logout(BuildContext context) {
    auth.signOutUser();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
