import 'package:android_development_secquraise/style/palette.dart';
import 'package:flutter/material.dart';

class RowTextWidget extends StatelessWidget {
  final String text1;
  final String text2;
  const RowTextWidget({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 23),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: const TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w400,
              color: Palette.secondaryColor 
            ),
          ),
          
          Text(
            text2,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Palette.primaryColor 
            ),
          ),
        ],
      ),
    );
  }
}