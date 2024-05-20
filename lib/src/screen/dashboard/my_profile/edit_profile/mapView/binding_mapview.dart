import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/mapView/controller_mapview.dart';

class BindingMapView implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerMapView());
  }
}
