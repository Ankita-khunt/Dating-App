import 'package:dating_app/imports.dart';

class CustomDialogBox extends StatefulWidget {
  final String firstBtnTitle;
  final String secondBtnTitle;
  final String title;
  final String? subtitle;
  final Widget? child;
  final VoidCallback? onClickedfirstbtn;
  final VoidCallback? onClickedsecondbtn;

  const CustomDialogBox({
    super.key,
    this.firstBtnTitle = '',
    this.secondBtnTitle = '',
    this.title = '',
    this.onClickedfirstbtn,
    this.onClickedsecondbtn,
    this.subtitle,
    this.child,
  });

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        widget.child ??
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: widget.title.isNotEmpty ? true : false,
                    child: CustomText(
                      text: widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyleConfig.boldTextStyle(
                          color: ColorConstants().black,
                          fontWeight: FontWeight.w700,
                          fontSize: TextStyleConfig.bodyText20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      child: CustomText(
                        text: widget.subtitle!,
                        maxlines: 20,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleConfig.regularTextStyle(
                            color: ColorConstants().grey1,
                            fontWeight: FontWeight.w400,
                            fontSize: TextStyleConfig.bodyText16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.31,
                          child: PlanButton(
                            btnTitle: widget.firstBtnTitle,
                            fontWeight: FontWeight.w700,
                            foregroundcolor: ColorConstants().primaryGradient,
                            backgroundColor: ColorConstants().white,
                            btnFontSize: TextStyleConfig.bodyText16,
                            onClicked: widget.onClickedfirstbtn,
                          ),
                        ),
                        Visibility(
                          visible: widget.secondBtnTitle.isNotEmpty ? true : false,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.31,
                                child: PrimaryButton(
                                  btnTitle: widget.secondBtnTitle,
                                  foregroundcolor: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  btnFontSize: TextStyleConfig.bodyText16,
                                  backgroundColor: ColorConstants().primaryGradient,
                                  onClicked: widget.onClickedsecondbtn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
