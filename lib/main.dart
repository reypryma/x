import 'package:flutter/material.dart';
import 'package:x/features/auth/view/login_view.dart';
import 'package:x/features/auth/view/signup_view.dart';
import 'package:x/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: const SignUpView(),
    );
  }
}
