import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/provider/auth_provider.dart';
import 'package:firebase_chat_app/services/auth/auth_service.dart';
import 'package:firebase_chat_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authPro = ref.watch(authProvider);
    final themePro = ref.watch(themeProvider);
    final auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              themePro.toggleTheme();
            },
            icon:
                Icon(themePro.isDarkMode ? Icons.light_mode : Icons.dark_mode)),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            onPressed: () {
              authPro.logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text(FirebaseAuth.instance.currentUser!.email!),
      ),
    );
  }
}
