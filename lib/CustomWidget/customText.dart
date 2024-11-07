import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines; // Added maxLines to control the line limit
  final TextOverflow? overflow;

  const CustomText({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontFamily,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 16.0, // Default size if none provided
        color: color ?? Colors.black, // Default color if none provided
        fontFamily: fontFamily, // Default is null, which means system default
        fontWeight: fontWeight ?? FontWeight.normal, // Default font weight if none provided
      ),
      textAlign: textAlign ?? TextAlign.start, // Default alignment
      maxLines: maxLines, // Allow multi-line text if maxLines is provided
      overflow: overflow ?? TextOverflow.visible, // Allow text to wrap to next line or overflow
    );
  }
}
