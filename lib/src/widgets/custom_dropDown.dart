import 'package:dating_app/imports.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String child;

  final void Function(T, int)? onChange;
  final void Function(bool value)? onOpenchanged;

  final List<DropdownItem<T>> items;
  final DropdownStyle dropdownStyle;

  final DropdownButtonStyle dropdownButtonStyle;

  final Icon? icon;
  final bool hideIcon;
  final String? leadingicon;

  final bool leadingIcon;
  final bool isCenter;
  final bool isCanTap;

  const CustomDropdown(
      {Key? key,
      this.hideIcon = false,
      required this.child,
      this.onOpenchanged,
      required this.items,
      this.leadingicon,
      this.dropdownStyle = const DropdownStyle(),
      this.dropdownButtonStyle = const DropdownButtonStyle(),
      this.icon,
      this.leadingIcon = false,
      this.onChange,
      this.isCenter = false,
      this.isCanTap = true})
      : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var style = const DropdownButtonStyle();
    // link the overlay to the button
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: CompositedTransformTarget(
        link: this._layerLink,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.transparent,
                blurRadius: 5.0, // soften the shadow
                spreadRadius: 1.0, //extend the shadow
                offset: Offset(
                  0.1, // Move to right 10  horizontally
                  0.1, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          height: 49,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants().white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: ColorConstants().lightgrey),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: _toggleDropdown,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: style.mainAxisAlignment ?? MainAxisAlignment.center,
                textDirection: widget.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.leadingicon != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: SizedBox(
                        height: 45,
                        width: 30,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(widget.leadingicon!),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  if (_currentIndex == -1) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: CustomText(
                        text: widget.child,
                        textScaleFactor: 1.0,
                        style: TextStyleConfig.regularTextStyle(
                            styleLineHeight: 1.0,
                            color: ColorConstants().black,
                            fontSize: TextStyleConfig.bodyText14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ] else ...[
                    widget.items[_currentIndex],
                  ],
                  if (!widget.isCenter) const Spacer(),
                  if (!widget.hideIcon)
                    RotationTransition(
                      turns: _rotateAnimation,
                      child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SvgPicture.asset(
                            ImageConstants.icon_downArrow,
                            height: 20,
                            width: 20,
                            fit: BoxFit.scaleDown,
                          )),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    var size = renderBox!.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: widget.dropdownStyle.width ?? size.width,
                child: CompositedTransformFollower(
                  offset: widget.dropdownStyle.offset ?? Offset(0, size.height + 5),
                  link: this._layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(24),
                    color: widget.dropdownStyle.color,
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation,
                      child: ConstrainedBox(
                        constraints: widget.dropdownStyle.constraints ??
                            BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height - topOffset - 15,
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(24)),
                            color: ColorConstants().white,
                          ),
                          child: Scrollbar(
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(12),
                              shrinkWrap: true,
                              children: widget.items.asMap().entries.map((item) {
                                return InkWell(
                                  hoverColor: ColorConstants().primaryGradient,
                                  onTap: () {
                                    setState(() => _currentIndex = item.key);
                                    _toggleDropdown(close: true);
                                    widget.onChange!(item.value.value as T, item.key);
                                  },
                                  child: item.value,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (widget.isCanTap) {
      FocusManager.instance.primaryFocus!.unfocus();

      if (_isOpen || close) {
        await _animationController.reverse();
        this._overlayEntry.remove();
        setState(() {
          _isOpen = false;
        });
      } else {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
        setState(() => _isOpen = true);
        _animationController.forward();
      }
    }
  }
}

/// DropdownItem is just a wrapper for each child in the dropdown list.\n
/// It holds the value of the item.
class DropdownItem<T> extends StatelessWidget {
  final T? value;
  final Widget? child;

  const DropdownItem({Key? key, this.value, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child!;
  }
}

class DropdownButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final ShapeBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;

  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });
}

class DropdownStyle {
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;

  /// position of the top left of the dropdown relative to the top left of the button
  final Offset? offset;

  ///button width must be set for this to take effect
  final double? width;

  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });
}
