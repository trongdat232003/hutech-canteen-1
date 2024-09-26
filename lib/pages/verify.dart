// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Nền xanh chứa logo và tiêu đề
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.5,
            color: const Color.fromARGB(255, 32, 113, 175),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo_hutech.png",
                  width: MediaQuery.of(context).size.width / 3,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Verification",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                const Text(
                  "We have sent a code to your email",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 5),
                const Text(
                  "example@gmail.com",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
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
          // Phần màu trắng bo góc phía dưới chứa form đăng nhập
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.6,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "CODE",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            "Resend",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(" in 50 sec")
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  // Sử dụng PinCodeTextField cho mã PIN
                  PinCodeTextField(
                    appContext: context,
                    length: 4, // Số lượng ô nhập mã PIN
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeColor: const Color.fromARGB(
                          42, 199, 193, 193), // Màu viền khi ô được chọn
                      selectedColor:
                          Colors.grey, // Màu viền khi ô đang được nhập
                      inactiveColor:
                          Colors.grey, // Màu viền khi ô không được chọn
                      activeFillColor: Colors.grey, // Màu nền khi ô có dữ liệu
                      selectedFillColor:
                          Colors.grey, // Màu nền khi ô đang được nhập
                      inactiveFillColor: Colors.white,
                    ),
                    enableActiveFill: true,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 30),
                  // Nút Submit
                  ElevatedButton(
                    onPressed: () {
                      // Thực hiện khi nhấn nút
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Verify",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
