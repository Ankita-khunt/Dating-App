import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  final String? text;
  final TextOverflow? overflow;
  final int? maxlines;
  final TextAlign? textAlign;
  final TextStyle? style;
  final bool? softWrap;
  @override
  final GlobalKey? key;

  final double? textScaleFactor;
  final EdgeInsetsGeometry? margin;

  const CustomText(
      {this.text,
      this.key,
      this.margin,
      this.style,
      this.textAlign,
      this.textScaleFactor = 1.0,
      this.softWrap,
      this.overflow,
      this.maxlines});

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
          key: widget.key,
          margin: widget.margin ?? EdgeInsets.zero,
          child: Text(widget.text!,
              textAlign: widget.textAlign,
              softWrap: widget.softWrap,
              overflow: widget.overflow,
              textScaleFactor: widget.textScaleFactor,
              maxLines: widget.maxlines,
              style: widget.style)),
    );
  }
}
