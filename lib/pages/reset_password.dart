import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // Controllers để quản lý đầu vào từ các ô nhập mật khẩu
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Biến để kiểm tra tính hợp lệ của mật khẩu xác nhận
  String? _errorMessage;

  // Hàm kiểm tra nếu mật khẩu xác nhận giống mật khẩu mới
  void _validatePasswords() {
    setState(() {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        _errorMessage = null; // Mật khẩu khớp
      } else {
        _errorMessage = "Passwords do not match"; // Mật khẩu không khớp
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Nền xanh chứa logo và tiêu đề
          Container(
            width: double.infinity,
            height: screenHeight / 2.5,
            color: const Color.fromARGB(255, 32, 113, 175),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/logo_hutech.png",
                  width: screenWidth / 3,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
          ),
          // Phần trắng chứa form nhập mật khẩu mới
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                height: screenHeight / 1.6,
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "NEW PASSWORD",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: "Enter your new password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "CONFIRM PASSWORD",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: "Confirm your new password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        _validatePasswords();
                      },
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_newPasswordController.text ==
                            _confirmPasswordController.text) {
                          // Xử lý logic khi mật khẩu khớp
                          // Ví dụ: Gửi mật khẩu mới lên server
                        } else {
                          _validatePasswords();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "SUBMIT",
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
        ],
      ),
    );
  }
}
