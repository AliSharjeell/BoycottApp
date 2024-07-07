import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final Size screenSize;
  const Button(
      {super.key,
      required this.onTap,
      required this.text,
      required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: screenSize.width * 0.05,
          left: screenSize.width * 0.05,
          bottom: screenSize.height * 0.018,
          top: screenSize.height * 0.015),
      child: GestureDetector(
          onTap: onTap,
          child: Container(
              padding: EdgeInsets.only(
                  top: screenSize.height * 0.011,
                  bottom: screenSize.height * 0.011),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 239, 0, 107),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                  child: Text(
                text,
                style: GoogleFonts.inter(
                    fontSize: screenSize.width * 0.06,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )))),
    );
  }
}
