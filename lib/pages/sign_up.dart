import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:hutech_cateen/services/apiAuth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText1 = true;

  final ApiAuth _apiAuth = ApiAuth();
  // void showSuccessToast() {
  //   Fluttertoast.showToast(
  //     msg: "Đăng ký thành công!",
  //     toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.TOP_RIGHT,
  //     backgroundColor: Colors.green,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //     timeInSecForIosWeb: 1,
  //     webBgColor: "linear-gradient(to right, #00b09b, #96c93d)",
  //     webPosition: "right",
  //   );
  // }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      var name = _nameController.text;
      var email = _emailController.text;
      var password = _passwordController.text;

      var success = await _apiAuth.signUp(name, email, password);
      if (success) {
        // showSuccessToast();
        Navigator.pushReplacementNamed(context, '/login');
      }
      // else {
      //   // Hiển thị thông báo lỗi cho người dùng
      //   Fluttertoast.showToast(
      //     msg: "Đăng ký thất bại!",
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Nền xanh chứa logo và tiêu đề
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.5,
            color: Color.fromARGB(255, 32, 113, 175),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/logo_hutech.png",
                  width: MediaQuery.of(context).size.width / 3,
                ),
                SizedBox(height: 10),
                Text(
                  "Đăng ký",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  "Vui lòng đăng ký để bắt đầu",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: BackButton(
              onPressed: () {
                Navigator.pop(context); // Quay lại trang trước
              },
              color: Colors.white,
            ),
          ),
          // Phần màu trắng bo góc phía dưới chứa form đăng ký
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Họ và tên",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Nhập họ và tên của bạn",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng không để trống";
                          }
                          final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
                          if (!nameRegExp.hasMatch(value)) {
                            return "Tên không được chứa số hoặc ký tự đặc biệt";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      Text(
                        "EMAIL",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Nhập email của bạn",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng không để trống";
                          }
                          final emailRegExp = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                          if (!emailRegExp.hasMatch(value)) {
                            return "Vui lòng nhập đúng định dạng";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Mật khẩu",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "Nhập mật khẩu của bạn",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng không để trống";
                          }
                          final passwordRegExp = RegExp(
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{6,}$');
                          if (!passwordRegExp.hasMatch(value)) {
                            return "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường và số";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Nhập lại mật khẩu",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _rePasswordController,
                        obscureText: _obscureText1,
                        decoration: InputDecoration(
                          labelText: "Nhập mật khẩu vừa nhập",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText1 = !_obscureText1;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng không để trống";
                          }
                          if (value != _passwordController.text) {
                            return "Mật khẩu không giống mật khẩu đã nhập";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
