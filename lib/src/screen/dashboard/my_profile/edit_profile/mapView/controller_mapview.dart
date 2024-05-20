import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/edit_profile.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/controller_edit_profile.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ControllerMapView extends GetxController {
//Search controller for MAP
  Rx<TextEditingController> searchController = TextEditingController().obs;

//LOCATION DATA
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  List<Marker> markers = <Marker>[];
  EditProfileResponse? editProfileResponse;
  String? currentAddress = "";

  // Position? currentPosition;

  Completer<GoogleMapController> mapController = Completer();

  LatLng? center;
  // Prediction? prediction;

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    addCustomIcon();
  }

  //LOCATION PERMISSION
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      openSettingsDialog(Get.overlayContext!).then((value) {
        getCurrentPosition();
      });
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        openSettingsDialog(Get.overlayContext!).then((value) {
          getCurrentPosition();
        });
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      openSettingsDialog(Get.overlayContext!).then((value) {
        getCurrentPosition();
      });
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      handleTap(center!);
      _getAddressFromLatLng(center!);
      update();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(LatLng latLong) async {
    await placemarkFromCoordinates(latLong.latitude, latLong.longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      String address = "";
      if (place.street != "") {
        address = "${place.street}";
      }
      if (place.subLocality != "") {
        address = "$address,${place.subLocality}";
      }
      if (place.locality != "") {
        address = "$address,${place.locality}";
      }
      if (place.postalCode != "") {
        address = "$address,${place.postalCode}";
      }
      if (place.administrativeArea != "") {
        address = "$address,${place.administrativeArea}";
      }
      if (place.country != "") {
        address = "$address,${place.country}";
      }
      currentAddress = address;
      update();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void addCustomIcon() async {
    final Uint8List mapicon = await getBytesFromAsset(ImageConstants.icon_pin_png, Platform.isAndroid ? 50 : 130);
    markerIcon = BitmapDescriptor.fromBytes(mapicon);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

  handleTap(LatLng point) {
    markers = [];
    markers.add(Marker(
      markerId: MarkerId(point.toString()),
      position: point,
      icon: markerIcon,
    ));

    Get.find<ControllerEditProfile>().selectedLocation.value = currentAddress;
    Get.find<ControllerEditProfile>().center = center;
    _getAddressFromLatLng(LatLng(point.latitude, point.longitude));
    update();
  }
}
