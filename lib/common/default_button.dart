

import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
  Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:300,
      height: 50,
      child: TextButton(
        onPressed: press,
        style: TextButton.styleFrom(
          backgroundColor: Colors.redAccent,
          textStyle: const TextStyle(fontSize: 20),
        ),  child: Text(
          text,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: "Poppins-Regular",
              fontWeight: FontWeight.normal
          ),
        ),
        clipBehavior: Clip.hardEdge,
       ),
    );
  }
}