library custom_check_box;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/constants/image_constant.dart';

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  final String? checkedIcon;

  final String? uncheckedIcon;
  final double? borderWidth;
  final double? checkBoxSize;
  final bool shouldShowBorder;
  final Color? borderColor;
  final double? borderRadius;
  final double? splashRadius;
  final Color? splashColor;
  final String? tooltip;
  final MouseCursor? mouseCursors;

  const CustomCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.checkedIcon = ImageConstants.icon_check,
    this.uncheckedIcon = ImageConstants.icon_uncheck,
    this.borderWidth,
    this.checkBoxSize,
    this.shouldShowBorder = false,
    this.borderColor,
    this.borderRadius,
    this.splashRadius,
    this.splashColor,
    this.tooltip,
    this.mouseCursors,
  }) : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late bool _checked;
  late CheckStatus _status;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(CustomCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    _checked = widget.value;
    if (_checked) {
      _status = CheckStatus.checked;
    } else {
      _status = CheckStatus.unchecked;
    }
  }

  Widget _buildIcon() {
    late String iconData;

    switch (_status) {
      case CheckStatus.checked:
        iconData = widget.checkedIcon!;
        break;
      case CheckStatus.unchecked:
        iconData = widget.uncheckedIcon!;
        break;
    }

    return SvgPicture.asset(
      iconData,
      width: widget.checkBoxSize ?? 18,
      height: widget.checkBoxSize ?? 18,
      fit: BoxFit.scaleDown,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      alignment: Alignment.centerLeft,
      icon: _buildIcon(),
      onPressed: () => widget.onChanged(!_checked),
      splashRadius: widget.splashRadius,
      splashColor: widget.splashColor,
      tooltip: widget.tooltip,
      mouseCursor: widget.mouseCursors ?? SystemMouseCursors.click,
    );
  }
}

enum CheckStatus {
  checked,
  unchecked,
}
