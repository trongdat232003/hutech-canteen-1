import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thanh Toán Thành Công')),
      body: Center(
        child: Text('Cảm ơn bạn! Thanh toán đã hoàn tất.'),
      ),
    );
    ;
  }
}
