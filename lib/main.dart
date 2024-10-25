import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hutech_cateen/pages/Profile.dart';
import 'package:hutech_cateen/pages/bottomnav.dart';
import 'package:hutech_cateen/pages/forgot_password.dart';
import 'package:hutech_cateen/pages/home.dart';
import 'package:hutech_cateen/pages/login.dart';
import 'package:hutech_cateen/pages/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    setState(() {
      _isLoggedIn =
          accessToken != null; // Nếu accessToken tồn tại thì đã đăng nhập
    });
  }

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
        '/success': (context) => SuccessScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Hiển thị BottomNav nếu đã đăng nhập, nếu không hiển thị Login
      home: _isLoggedIn ? BottomNav() : const Login(),
    );
  }
}
