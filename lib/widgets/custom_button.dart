import 'package:android_development_secquraise/style/palette.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Function() onPressed;
 

  const CustomButton({
    this.text,
    required this.onPressed,  
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Palette.buttonColor,
          borderRadius: BorderRadius.circular( 10.0), 
        ),
        child:  const Padding(
          padding:  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child:  Text("Manual Data Refresh",style: TextStyle(fontSize: 20),),
        ),
      ),
    );
  }
}
