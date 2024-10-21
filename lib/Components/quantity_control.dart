import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;
  final int maxInventory;

  const QuantityControl({
    Key? key,
    required this.quantity,
    required this.onQuantityChanged,
    required this.maxInventory,
  }) : super(key: key);

  void handleIncrease() {
    if (quantity < maxInventory) {
      onQuantityChanged(quantity + 1);
    }
  }

  void handleDecrease() {
    if (quantity > 1) {
      onQuantityChanged(quantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Colors.white,
              size: 10,
            ),
            onPressed: handleDecrease,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Text(
              '$quantity',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 10,
            ),
            onPressed: handleIncrease,
          ),
        ],
      ),
    );
  }
}
