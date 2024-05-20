import 'package:dating_app/imports.dart';

class BaseController extends StatelessWidget {
  final Widget widgetsScaffold;
  final String? scaffoldBackground;

  const BaseController(
      {required this.widgetsScaffold, this.scaffoldBackground, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Stack(
        children: [
          Image.asset(
            scaffoldBackground ?? ImageConstants.scaffold_bg,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          widgetsScaffold
        ],
      ),
    );
  }
}
