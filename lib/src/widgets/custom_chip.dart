import 'package:dating_app/imports.dart';
import 'package:flutter/foundation.dart';

class MultiSelectChip extends StatefulWidget {
  final bool? isMultiSelection;
  final List<dynamic> list;
  final List<dynamic>? selectedChoices;
  final bool? isSelectable;

  final Function(List<dynamic>)? onSelectionChanged;
  final Function(List<dynamic>)? onMaxSelected;
  final int? maxSelection;

  const MultiSelectChip(this.list,
      {super.key,
      this.isSelectable = true,
      this.onSelectionChanged,
      this.selectedChoices,
      this.isMultiSelection = true,
      this.onMaxSelected,
      this.maxSelection = 10000});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  _buildMultiChoiceList() {
    List<Widget> choices = [];

    for (var item in widget.list) {
      choices.add(Padding(
        padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          label: CustomText(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
              text: item.name!,
              style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText14,
                fontWeight: FontWeight.w500,
                // ignore: unrelated_type_equality_checks
                color: checkId(item) ? ColorConstants().white : ColorConstants().black,
              )),
          backgroundColor: checkId(item) ? ColorConstants().primaryGradient : ColorConstants().white,
          selectedColor: checkId(item) ? ColorConstants().primaryGradient : ColorConstants().white,
          elevation: 0.0,
          side: BorderSide(
            width: 1,
            color: checkId(item) ? ColorConstants().primaryGradient : ColorConstants().lightgrey,
          ),
          selected: checkId(item),
          onSelected: (selected) {
            if (widget.isSelectable!) {
              if (widget.selectedChoices!.isNotEmpty &&
                  widget.selectedChoices!.length == (widget.maxSelection ?? -1) &&
                  !widget.selectedChoices!.contains(item)) {
                widget.onMaxSelected?.call(widget.selectedChoices!);
              } else {
                setState(() {
                  checkId(item)
                      ? widget.selectedChoices!.removeWhere((element) => element.id == item.id)
                      : widget.selectedChoices!.add(item);
                  setState(() {});
                  widget.onSelectionChanged?.call(widget.selectedChoices!);
                });
              }
            }
          },
          showCheckmark: false,
        ),
      ));
    }

    return choices;
  }

  bool checkId(dynamic item) {
    Iterable isSameIDs;

    if (widget.selectedChoices != null) {
      isSameIDs = widget.selectedChoices!.where((element) => element.id == item.id);
      if (kDebugMode) {
        print(isSameIDs);
      }
      return isSameIDs.isEmpty ? false : true;
    } else {
      return false;
    }
  }

  _buildSingleChoiceList() {
    List<Widget> choices = [];

    for (var item in widget.list) {
      choices.add(Padding(
        padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          label: CustomText(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
              text: item.name!,
              style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText14,
                fontWeight: FontWeight.w500,
                color: widget.selectedChoices!.contains(item) ? ColorConstants().white : ColorConstants().black,
              )),
          backgroundColor: ColorConstants().white,
          selectedColor: ColorConstants().primaryGradient,
          elevation: 0.0,
          side: BorderSide(
            width: 1,
            color:
                widget.selectedChoices!.contains(item) ? ColorConstants().primaryGradient : ColorConstants().lightgrey,
          ),
          selected: widget.selectedChoices!.contains(item),
          onSelected: (selected) {
            if (widget.isSelectable!) {
              widget.selectedChoices!.clear();
              widget.selectedChoices!.add(item);
              widget.onSelectionChanged?.call(widget.selectedChoices!);
            }
          },
          showCheckmark: false,
        ),
      ));
    }

    return choices;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.isMultiSelection! ? _buildMultiChoiceList() : _buildSingleChoiceList(),
    );
  }
}
