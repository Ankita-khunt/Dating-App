//Primary Button with Gradient
import 'package:dating_app/imports.dart';

class PrimaryButton extends StatefulWidget {
  final String btnTitle;
  final Color? foregroundcolor;
  final double btnHeight;
  final double? btnWidth;
  final Color? backgroundColor;
  final VoidCallback? onClicked;
  final double? btnFontSize;
  final double borderRadius;
  final FontWeight? fontWeight;
  final double fontsize;

  const PrimaryButton({
    Key? key,
    required this.btnTitle,
    this.borderRadius = 10,
    this.backgroundColor,
    this.fontsize = 16,
    this.btnHeight = 48,
    this.btnWidth,
    this.foregroundcolor,
    this.onClicked,
    this.btnFontSize,
    this.fontWeight = FontWeight.w700,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: ColorConstants().lightgrey,
      hoverColor: ColorConstants().primaryGradient,
      onTap: widget.onClicked,
      child: Container(
        width: widget.btnWidth != null ? widget.btnWidth! : Get.width,
        height: widget.btnHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [ColorConstants().primaryGradient, ColorConstants().secondaryGradient]),
          borderRadius: BorderRadius.all(Radius.circular(widget.btnHeight / 2)),
        ),
        child: Center(
            child: CustomText(
                text: toLabelValue(widget.btnTitle),
                style: TextStyleConfig.boldTextStyle(
                    color: widget.foregroundcolor ?? Colors.white,
                    styleLineHeight: 1.2,
                    fontSize: widget.fontsize,
                    fontWeight: widget.fontWeight))),
      ),
    );
  }
}

///GREY BUTTON

class PlanButton extends StatefulWidget {
  final String btnTitle;
  final Color? foregroundcolor;
  final Color? backgroundColor;

  final double? btnHeight;
  final double? btnWidth;

  final VoidCallback? onClicked;
  final double? btnFontSize;
  final Widget? preffixIcon;

  final FontWeight? fontWeight;

  const PlanButton({
    Key? key,
    required this.btnTitle,
    this.btnHeight = 48,
    this.btnWidth,
    this.backgroundColor,
    this.preffixIcon,
    this.foregroundcolor,
    this.onClicked,
    this.btnFontSize,
    this.fontWeight = FontWeight.w700,
  }) : super(key: key);

  @override
  State<PlanButton> createState() => _PlanButtonState();
}

class _PlanButtonState extends State<PlanButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onClicked,
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            elevation: 0,
            backgroundColor: widget.backgroundColor ?? ColorConstants().white,
            foregroundColor: widget.foregroundcolor ?? ColorConstants().primaryGradient,
            disabledBackgroundColor: ColorConstants().white,
            disabledForegroundColor: ColorConstants().primaryGradient,
            fixedSize: Size(widget.btnWidth != null ? widget.btnWidth! : Get.width, widget.btnHeight!),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: widget.onClicked != null
                        ? ColorConstants().primaryGradient
                        : ColorConstants().primaryGradient.withOpacity(0.2)),
                borderRadius: BorderRadius.all(Radius.circular(widget.btnHeight! / 2)))),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.preffixIcon != null) widget.preffixIcon!,
            CustomText(
                text: toLabelValue(widget.btnTitle),
                style: TextStyleConfig.boldTextStyle(
                  color: widget.foregroundcolor,
                  styleLineHeight: 1.2,
                  fontSize: TextStyleConfig.bodyText16,
                )),
          ],
        )));
  }
}
