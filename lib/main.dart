import 'package:flutter/material.dart';
import 'package:hutech_cateen/pages/Order.dart';
import 'package:hutech_cateen/pages/Profile.dart';
import 'package:hutech_cateen/pages/bottomnav.dart';
import 'package:hutech_cateen/pages/forgot_password.dart';
import 'package:hutech_cateen/pages/home.dart';
import 'package:hutech_cateen/pages/login.dart';
import 'package:hutech_cateen/pages/reset_password.dart';
import 'package:hutech_cateen/pages/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUp(),
        '/home': (context) => const Home(),
        '/forgot-password': (context) => const ForgotPassword(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}
