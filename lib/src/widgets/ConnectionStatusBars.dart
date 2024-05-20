import 'package:dating_app/imports.dart';

class ConnectionStatusBars extends StatelessWidget {
  const ConnectionStatusBars({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        height: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(ImageConstants.no_internet_connection),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
