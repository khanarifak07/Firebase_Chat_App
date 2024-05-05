import 'package:firebase_chat_app/provider/auth_provider.dart';
import 'package:firebase_chat_app/screens/auth/login_page.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final authPro = ref.watch(authProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 15,
                left: 12,
                right: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Register",
                  style: TextStyle(fontSize: 50),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    authPro.pickAvatar();
                  },
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * .12,
                    backgroundImage: authPro.avatar != null
                        ? FileImage(authPro.avatar!)
                        : null,
                    child: authPro.avatar == null
                        ? const Icon(Icons.person, size: 50)
                        : Container(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: authPro.nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: authPro.emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: authPro.passwordController,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: authPro.confirmPasswordController,
                  decoration: const InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                authPro.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          authPro.registerUser(context);
                        },
                        child: const Text("Register"),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    GestureDetector(
                      onTap: () {
                        navigateToScreen(context, const LoginPage());
                      },
                      child: Text(
                        "Login now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
