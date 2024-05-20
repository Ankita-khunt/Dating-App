import 'package:dating_app/imports.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onValueChanged;
  final VoidCallback onRemoveValue;
  final VoidCallback? onTap;
  final bool? isPrimaryIconColor;
  final String? hintText;
  final bool? isEnable;

  const CustomSearchBar(
      {Key? key,
      this.controller,
      this.onValueChanged,
      this.isEnable = true,
      this.onTap,
      this.isPrimaryIconColor = false,
      required this.onRemoveValue,
      this.hintText})
      : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final _focusNodesearch = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstants().white,
          border: Border.all(color: ColorConstants().lightgrey),
          borderRadius: const BorderRadius.all(Radius.circular(24))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.12,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: SvgPicture.asset(
                ImageConstants.icon_search,
                color: widget.isPrimaryIconColor != null ? ColorConstants().primaryGradient : ColorConstants().grey1,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              focusNode: _focusNodesearch,
              onChanged: widget.onValueChanged,
              controller: widget.controller,
              cursorColor: ColorConstants().grey1,
              onTap: widget.onTap,
              enabled: widget.isEnable,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: widget.hintText,
                fillColor: const Color.fromRGBO(112, 112, 112, 1),
                hintStyle: const TextStyle(fontSize: 14),
                suffixIcon: Visibility(
                  visible: widget.controller!.text != "" ? true : false,
                  child: IconButton(
                    onPressed: widget.onRemoveValue,
                    icon: Icon(
                      Icons.close,
                      color: ColorConstants().grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
