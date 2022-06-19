import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';

class NotifiedScreen extends StatelessWidget {
  final String? label;

  const NotifiedScreen({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: lightBlue,
          ),
        ),
        title: Text(
          this.label.toString().split("|")[0],
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.green),
          child: Center(
            child: Text(
              this.label.toString().split("|")[1],
              style: TextStyle(
                color: Colors.black,
                fontSize: 30
              ),
            ),
          ),
        ),
      ),
    );
  }
}
