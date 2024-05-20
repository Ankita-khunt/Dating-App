import 'package:flutter/material.dart';

import '../utils/constants/color_constants.dart';

class CustomGradientCard extends StatefulWidget {
  final Color? shadowColor;
  final double? borderradius;
  final Widget child;
  final Color? bordercolor;

  final bool? isgradientBorder;

  const CustomGradientCard(
      {super.key,
      this.shadowColor,
      required this.borderradius,
      this.isgradientBorder = false,
      this.bordercolor,
      required this.child});

  @override
  State<CustomGradientCard> createState() => _CustomGradientCardState();
}

class _CustomGradientCardState extends State<CustomGradientCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants().primaryGradient,
        borderRadius: BorderRadius.circular(widget.borderradius!),
        gradient: widget.isgradientBorder == true
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorConstants().primaryGradient,
                  ColorConstants().secondaryGradient
                ],
                tileMode: TileMode.clamp)
            : const LinearGradient(
                colors: [Colors.transparent, Colors.transparent]),
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.isgradientBorder == true ? 1.0 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            color: ColorConstants().white,
            borderRadius: BorderRadius.circular(widget.borderradius! - 1),
            border: Border.all(
                width: widget.isgradientBorder == true ? 0 : 1,
                color: widget.isgradientBorder == true
                    ? Colors.transparent
                    : widget.bordercolor != null
                        ? ColorConstants().grey
                        : ColorConstants().lightgrey),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor ??
                    ColorConstants().white.withOpacity(.11),
                spreadRadius: 0,
                blurRadius: 40,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final Color? shadowColor;
  final double? borderradius;
  final Color? backgroundColor;
  final Widget child;

  final bool? isGradientCard;
  final Color? primaryGradient;
  final Color? secondaryGradient;
  final Color? bordercolor;
  final double? borderwidth;

  const CustomCard(
      {super.key,
      this.shadowColor,
      required this.borderradius,
      this.bordercolor,
      this.isGradientCard,
      this.primaryGradient,
      this.borderwidth,
      this.secondaryGradient,
      this.backgroundColor,
      required this.child});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? ColorConstants().white,
        borderRadius: BorderRadius.circular(widget.borderradius!),
        border: Border.all(
            width: widget.borderwidth ?? 1,
            color: widget.bordercolor ?? ColorConstants().lightgrey),
        gradient: widget.isGradientCard!
            ? LinearGradient(
                colors: [widget.secondaryGradient!, widget.primaryGradient!],
                tileMode: TileMode.clamp)
            : null,
        boxShadow: [
          BoxShadow(
            color:
                widget.shadowColor ?? ColorConstants().grey1.withOpacity(.24),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(1, 4), // changes position of shadow
          ),
        ],
      ),
      child: widget.child,
    );
  }
}
