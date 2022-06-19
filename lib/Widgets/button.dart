import 'package:flutter/material.dart';
import 'package:pfc/constants.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final double height;
  final double width;
  const MyButton({Key? key, required this.label, required this.onTap, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: lightBlue,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
