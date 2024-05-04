import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/screens/auth/login_page.dart';
import 'package:firebase_chat_app/screens/homepage/homepage.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if user logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
          //user not logged in
          else {
            return const LoginPage();
          }
        });
  }
}
