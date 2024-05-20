import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/setup_profile_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdownButton2 extends StatelessWidget {
  const CustomDropdownButton2({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
    this.onTapClose,
    super.key,
  });

  final String hint;
  final String? value;
  final List<ProfileFieldResponse> dropdownItems;
  final String? Function()? onTapClose;

  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;

  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: CustomText(
                text: hint,
                style: TextStyleConfig.regularTextStyle(
                  styleLineHeight: 1.0,
                  color: ColorConstants().black,
                  fontSize: TextStyleConfig.bodyText14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: dropdownItems.map((ProfileFieldResponse item) {
          // if (value == item.name) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: CustomText(
                  text: item.name!.capitalizeFirst,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleConfig.regularTextStyle(
                    styleLineHeight: 1.0,
                    color: ColorConstants().black,
                    fontSize: TextStyleConfig.bodyText14,
                  )),
            ),
          );
          //;
          // } else {
          //   return DropdownMenuItem<String>(
          //     value: item.name,
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 14),
          //       child: CustomText(
          //           text: item.name!,
          //           overflow: TextOverflow.ellipsis,
          //           style: TextStyleConfig.regularTextStyle(
          //             styleLineHeight: 1.0,
          //             color: ColorConstants().black,
          //             fontSize: TextStyleConfig.bodyText14,
          //           )),
          //     ),
          //   );
          // }
        }).toList(),
        value: value,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 50,
          // width: 160,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            border: Border.all(
              color: Colors.black26,
            ),
            color: ColorConstants().white,
          ),
          elevation: 0,
        ),
        iconStyleData: IconStyleData(
          icon: value != null
              ? InkWell(
                  onTap: onTapClose,
                  child: onTapClose != null
                      ? const Icon(Icons.close)
                      : const Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                )
              : const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
          iconSize: 14,
          iconEnabledColor: Colors.black,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          // maxHeight: 200,
          // width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: ColorConstants().white,
          ),
          // offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40,
          padding: const EdgeInsets.only(left: 0, right: 0),
          selectedMenuItemBuilder: (ctx, child) {
            return Container(
              color: ColorConstants().primaryLight,
              child: child,
            );
          },
        ),
      ),
    );
  }
}

class MultiSelectDropdown extends StatefulWidget {
  List<dynamic>? items;
  List<String> selectedItems;
  List<String> selectedItemsIDs;

  final void Function(List value)? onchanged;

  MultiSelectDropdown(
      {super.key,
      this.items,
      required this.selectedItems,
      required this.selectedItemsIDs,
      this.onchanged});

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  // List<String> selectedItems = [];
  // List<String> selectedItemsIDs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // selectedItems = widget.selectedItems;
    // selectedItemsIDs = widget.selectedItemsIDs;
    // print("+++   ${selectedItems.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<dynamic>(
          isExpanded: true,
          hint: CustomText(
            text: toLabelValue(StringConstants.select_option),
            style: TextStyleConfig.regularTextStyle(
              styleLineHeight: 1.0,
              color: ColorConstants().black,
              fontSize: TextStyleConfig.bodyText14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          items: widget.items!.map((item) {
            return DropdownMenuItem(
              value: item.id,
              //disable default onTap to avoid closing menu when selecting an item
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = widget.selectedItemsIDs.contains(item.id);
                  return InkWell(
                    onTap: () {
                      isSelected
                          ? widget.selectedItemsIDs.remove(item.id)
                          : widget.selectedItemsIDs.add(item.id);
                      isSelected
                          ? widget.selectedItems.remove(item.name)
                          : widget.selectedItems.add(item.name);

                      widget.onchanged != null
                          ? widget.onchanged!(widget.selectedItemsIDs)
                          : null;
                      //This rebuilds the StatefulWidget to update the button's text
                      setState(() {});
                      //This rebuilds the dropdownMenu Widget to update the check mark
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          if (isSelected)
                            SvgPicture.asset(ImageConstants.icon_check)
                          else
                            SvgPicture.asset(ImageConstants.icon_uncheck),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
          value: widget.selectedItems.isEmpty
              ? null
              : widget.selectedItemsIDs.last,
          onChanged: (value) {
            widget.onchanged != null ? widget.onchanged!(value) : null;
          },
          selectedItemBuilder: (context) {
            return widget.items!.map(
              (item) {
                return Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    widget.selectedItems.join(', '),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                );
              },
            ).toList();
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            // width: 160,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: Colors.black26,
              ),
              color: ColorConstants().white,
            ),
            elevation: 0,
          ),
          dropdownStyleData: DropdownStyleData(
            // maxHeight: 200,
            // width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ColorConstants().white,
            ),
            // offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
