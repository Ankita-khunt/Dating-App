import 'package:flutter/material.dart';

import '../utils/constants/color_constants.dart';

class CustomDivider extends StatefulWidget {
  final double? lineHeight;
  Color? backgroundColor;

  CustomDivider({Key? key, this.lineHeight = 1, this.backgroundColor})
      : super(key: key);

  @override
  State<CustomDivider> createState() => _CustomDividerState();
}

class _CustomDividerState extends State<CustomDivider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        color: widget.backgroundColor != null
            ? widget.backgroundColor!
            : ColorConstants().lightBGgrey,
        height: widget.lineHeight,
      ),
    );
  }
}
