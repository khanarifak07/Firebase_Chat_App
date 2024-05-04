import 'package:firebase_chat_app/firebase_options.dart';
import 'package:firebase_chat_app/screens/auth/auth_gate.dart';
import 'package:firebase_chat_app/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePro = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      home: const AuthGate(),
      theme: themePro.themeData,
    );
  }
}
