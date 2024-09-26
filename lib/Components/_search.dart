import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          color: const Color.fromARGB(31, 212, 200, 200),
          borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search Products",
            hintStyle: AppWidget.lightTextFieldStyle(),
            prefixIcon: Icon(Icons.search)),
      ),
    );
  }
}
