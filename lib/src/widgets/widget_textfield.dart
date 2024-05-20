import 'package:dating_app/imports.dart';

class CustomTextfieldWidget extends StatefulWidget {
  final String? placeholder;
  final int? maxLines;
  final Widget? fieldIcon;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  final bool? isSecuretext;
  bool? alignLabelWithHint;
  bool? isValid;

  final String? labelText;
  Widget? prefix;
  final double? borderRadius;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputformater;
  final void Function(String value)? onchanged;
  final Function(String?)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final GlobalKey<FormState>? formkey;
  final bool enable;
  final Iterable<String>? autofillHints;
  final Color? fillcolor;
  final bool hasboxDecoration;
  final FocusNode? focusnode;
  final TextAlign? textAlign;
  final bool enableinteractiveSelection;
  final TextCapitalization? textcapitalization;
  final EdgeInsets? contentPadding;
  final Color? borderColor;
  final String? initialValue;
  final Function? onTap;
  final bool? readOnly;
  final EdgeInsets? scrollPadding;
  TextInputAction? textInputAction;
  final int? maxLength;

  CustomTextfieldWidget(
      {super.key,
      this.formkey,
      this.readOnly,
      this.onFieldSubmitted,
      this.suffixIcon,
      this.preffixIcon,
      this.inputformater,
      this.prefix,
      this.borderRadius,
      this.maxLength,
      this.autofillHints,
      this.labelText,
      this.onchanged,
      this.alignLabelWithHint = false,
      this.placeholder,
      this.enable = true,
      this.validator,
      this.initialValue,
      this.controller,
      this.isValid = true,
      this.fieldIcon,
      this.textAlign,
      this.hasboxDecoration = true,
      this.maxLines = 1,
      this.isSecuretext = false,
      this.borderColor = Colors.grey,
      this.fillcolor,
      this.textcapitalization = TextCapitalization.sentences,
      this.keyboardType,
      this.focusnode,
      this.enableinteractiveSelection = true,
      this.contentPadding,
      this.scrollPadding,
      this.textInputAction = TextInputAction.next,
      this.onTap});

  @override
  _CustomTextfieldWidgetState createState() => _CustomTextfieldWidgetState();
}

class _CustomTextfieldWidgetState extends State<CustomTextfieldWidget>
    with SingleTickerProviderStateMixin {
  bool isValid = false;
  final _keyTextfield = GlobalKey();
  var textfieldHeight = 49;

  void setValidator(valid) {
    setState(() {
      isValid = valid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: SizedBox(
        height: 49,
        key: _keyTextfield,
        child: Form(
          key: widget.formkey,
          child: TextFormField(
            autofillHints: widget.autofillHints,
            readOnly: widget.readOnly ?? false,
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            enableInteractiveSelection: widget.enableinteractiveSelection,
            enabled: widget.enable,
            textAlign: TextAlign.left,
            focusNode: widget.focusnode,
            inputFormatters: widget.inputformater,
            cursorColor: ColorConstants().grey1,
            maxLength: widget.maxLength,
            onTap: () {
              setValidator(false);
            },
            textCapitalization: widget.textcapitalization!,
            validator: (text) {
              if (text!.isEmpty || text.trim() == "") {
                setValidator(true);
              } else {
                setValidator(false);
              }
              return null;
            },
            onChanged: (value) {
              widget.onchanged != null ? widget.onchanged!(value) : null;
            },
            onFieldSubmitted: widget.onFieldSubmitted,
            style: TextStyleConfig.regularTextStyle(
              color: widget.enable
                  ? ColorConstants().black
                  : ColorConstants().lightgrey,
              fontSize: TextStyleConfig.bodyText14,
            ),
            autofocus: false,
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            obscureText: widget.isSecuretext!,
            maxLines: widget.maxLines,
            scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
            decoration: InputDecoration(
              labelStyle: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText14,
                color: ColorConstants().lightgrey,
              ),
              hintText: widget.placeholder!,
              alignLabelWithHint: widget.alignLabelWithHint,

              hintStyle: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText14,
                color: ColorConstants().grey,
              ),

              prefix: widget.prefix,
              focusedErrorBorder: isValid && !widget.isValid!
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(textfieldHeight / 2),
                      borderSide: BorderSide(
                          color: ColorConstants().errorRed, width: 1))
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(textfieldHeight / 2),
                      borderSide: BorderSide(
                          color: ColorConstants().errorRed, width: 1)),
              errorBorder: isValid && !widget.isValid!
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(textfieldHeight / 2),
                      borderSide: BorderSide(
                          color: ColorConstants().errorRed, width: 1))
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(textfieldHeight / 2),
                      borderSide: BorderSide(
                          color: ColorConstants().errorRed, width: 1)),

              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.preffixIcon ??
                  Container(
                    width: 0,
                  ),

              // set the prefix icon constraints
              prefixIconConstraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 24,
              ),

              focusedBorder: !widget.isValid!
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? textfieldHeight / 2),
                      borderSide: BorderSide(
                          color: ColorConstants().errorRed, width: 1))
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? textfieldHeight / 2),
                      borderSide: BorderSide(
                          color:
                              widget.borderColor ?? ColorConstants().lightgrey,
                          width: 1)),

              contentPadding: widget.contentPadding ??
                  const EdgeInsets.only(left: 4, bottom: 4, top: 4, right: 4),

              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? textfieldHeight / 2),
                  borderSide: BorderSide(
                      color: widget.borderColor ?? ColorConstants().lightgrey,
                      width: 1)),

              filled: true,
              fillColor: widget.fillcolor ?? Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

//Formatter For initial Space
class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}
