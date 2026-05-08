import 'package:flutter/material.dart';

import 'view/login_view.dart';
import 'view/register_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dayflow',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101010),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFBA150),
          secondary: Color(0xFFFBA150),
          surface: Color(0xFF161616),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2B2B2B),
          hintStyle: const TextStyle(color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const LoginView(),
      routes: {
        '/register': (_) => const RegisterView(),
      },
    );
  }
}
