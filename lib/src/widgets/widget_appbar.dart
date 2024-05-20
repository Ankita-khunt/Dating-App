import 'package:dating_app/imports.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool? isBackVisible;
  final VoidCallback? onBack;
  final String? backWidgetIcon;
  FontWeight? fontweight;
  Color? backIconColor;
  final double? titleFontsize;
  final Color? titleColor;
  final Widget? secondTrailing;
  final Color? backgroundColor;
  final Widget? firstTrailing;
  final Widget? firstleading;
  final Widget? thirdTrailing;
  final bool? isFromDashBoard;
  final Widget? searchBar;
  final bool showAppbarLine;
  final bool? isCenterTitle;
  final TextStyle? textstyle;
  final Widget? isTitleWidget;
  final VoidCallback? onSecondOnclick;
  final VoidCallback? onThirdOnclick;

  final VoidCallback? onfirstOnclick;
  final bool? isGradientAppBar;
  final PreferredSizeWidget? bottom;

  CustomAppBar(
      {super.key,
      this.titleColor,
      this.searchBar,
      this.isCenterTitle = false,
      this.textstyle,
      this.isFromDashBoard = false,
      this.firstleading,
      this.isTitleWidget,
      this.backIconColor,
      this.isGradientAppBar = false,
      this.showAppbarLine = false,
      required this.title,
      this.titleFontsize,
      this.backWidgetIcon,
      this.onThirdOnclick,
      this.thirdTrailing,
      this.bottom,
      this.secondTrailing,
      this.isBackVisible = false,
      this.backgroundColor,
      this.onBack,
      this.fontweight = FontWeight.normal,
      this.firstTrailing,
      this.onSecondOnclick,
      this.onfirstOnclick});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: widget.isGradientAppBar!
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [ColorConstants().primaryGradient, ColorConstants().secondaryGradient])
                  : null,
            ),
            child: AppBar(
              bottom: widget.bottom,
              backgroundColor: widget.backgroundColor ?? Colors.transparent,
              // status bar and navigation bar color
              titleSpacing: widget.isBackVisible == true ? 0.0 : 16,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              centerTitle: widget.isCenterTitle,
              leading: widget.isBackVisible!
                  ? InkWell(
                      onTap: widget.onBack ??
                          () {
                            dismissKeyboard();

                            Get.back();
                          },
                      child: SvgPicture.asset(widget.backWidgetIcon ?? ImageConstants.icon_back,
                          color: widget.backIconColor != ""
                              ? widget.backIconColor
                              : widget.titleColor ?? ColorConstants().white,
                          height: 13,
                          width: 8,
                          fit: BoxFit.scaleDown),
                    )
                  : widget.isFromDashBoard!
                      ? const SizedBox()
                      : null,

              title: widget.isTitleWidget ??
                  widget.firstleading ??
                  (widget.title != ""
                      ? SizedBox(
                          child: Padding(
                            padding: EdgeInsets.only(top: (widget.isCenterTitle ?? false) ? 10 : 0),
                            child: CustomText(
                              text: widget.title,
                              overflow: TextOverflow.ellipsis,
                              textAlign: widget.isCenterTitle! ? TextAlign.center : TextAlign.left,
                              style: widget.textstyle ??
                                  TextStyleConfig.regularTextStyle(
                                    color: (widget.titleColor) ?? ColorConstants().black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: widget.titleFontsize ?? TextStyleConfig.bodyText16,
                                  ),
                            ),
                          ),
                        )
                      : widget.searchBar),

              actions: <Widget>[
                widget.thirdTrailing != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 10),
                        child: InkWell(
                          onTap: widget.onThirdOnclick,
                          child: widget.thirdTrailing,
                        ))
                    : const SizedBox(),
                widget.secondTrailing != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 10),
                        child: InkWell(
                          onTap: widget.onSecondOnclick,
                          child: widget.secondTrailing,
                        ))
                    : const SizedBox(),
                widget.firstTrailing != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 8),
                        child: InkWell(
                          onTap: widget.onfirstOnclick,
                          child: widget.firstTrailing,
                        ))
                    : const SizedBox(),
              ],
            ),
          ),
          widget.showAppbarLine
              ? Container(
                  height: 1,
                  color: ColorConstants().lightgrey.withOpacity(0.4),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
