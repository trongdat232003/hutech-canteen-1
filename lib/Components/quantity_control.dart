import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;

  const QuantityControl({
    Key? key,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  void handleIncrease() {
    onQuantityChanged(quantity + 1);
  }

  void handleDecrease() {
    if (quantity > 1) {
      onQuantityChanged(quantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: Colors.white),
            onPressed: handleDecrease,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$quantity',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: handleIncrease,
          ),
        ],
      ),
    );
  }
}
