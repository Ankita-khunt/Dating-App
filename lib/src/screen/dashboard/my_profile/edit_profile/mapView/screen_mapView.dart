// ignore_for_file: file_names

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/controller_edit_profile.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/mapView/controller_mapview.dart';
import 'package:dating_app/src/widgets/custom_searchBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class ScreenMapView extends StatelessWidget {
  ScreenMapView({super.key});

  final mapController = Get.find<ControllerMapView>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
      widgetsScaffold: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants().white,
        body: GetBuilder<ControllerMapView>(
          builder: (controller) {
            return controller.center == null
                ? const SizedBox()
                : SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _widgetSearchBar(),

                        /// You can drop pin label
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: CustomText(
                            text: toLabelValue(StringConstants.you_can_drp_pin),
                            textAlign: TextAlign.center,
                            style: TextStyleConfig.boldTextStyle(
                                fontSize: TextStyleConfig.bodyText20,
                                fontWeight: FontWeight.w700,
                                color: ColorConstants().black),
                          ),
                        ),

                        /// Current Location Label
                        _widgetCurrentLocation(),

                        const SizedBox(
                          height: 8,
                        ),
                        _widgetAddress(),

                        const SizedBox(
                          height: 12,
                        ),

                        _widgetMap(),

                        _widgetButtonDone(),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _widgetSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.find<ControllerEditProfile>().update();
              mapController.update();
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
              child: SvgPicture.asset(ImageConstants.icon_back),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                    context: Get.overlayContext!,
                    apiKey: googleAPIKey,
                    mode: Mode.overlay,
                    types: [],
                    strictbounds: false,
                    components: [Component(Component.country, 'in'), Component(Component.country, 'au')],
                    //google_map_webservice package
                    onError: (err) {
                      if (kDebugMode) {
                        print(err);
                      }
                    });

                if (place != null) {
                  mapController.currentAddress = place.description.toString();

                  //form google_maps_webservice package
                  final plist = GoogleMapsPlaces(
                    apiKey: googleAPIKey,
                  );
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  var newlatlang = LatLng(lat, lang);

                  //move map camera to selected place with animation
                  mapController.center = newlatlang;
                  mapController.update();
                  mapController.markers = [];

                  mapController.handleTap(newlatlang);

                  Get.find<ControllerEditProfile>().update();
                  final GoogleMapController controller = await mapController.mapController.future;

                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: newlatlang,
                        zoom: 16,
                        tilt: 50.0,
                        bearing: 45.0,
                      ),
                    ),
                  );
                }
              },
              child: CustomSearchBar(
                controller: mapController.searchController.value,
                isEnable: false,
                hintText: toLabelValue(StringConstants.search_for_your_location),
                onRemoveValue: () {
                  mapController.searchController.value.clear();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetCurrentLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: toLabelValue(StringConstants.current_location),
            textAlign: TextAlign.center,
            style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w500, color: ColorConstants().grey1),
          ),
          InkWell(
            onTap: () {
              Get.find<ControllerEditProfile>().selectedLocation.value = mapController.currentAddress;
              Get.find<ControllerEditProfile>().center = mapController.center;
              Get.back();
              Get.find<ControllerEditProfile>().update();
            },
            child: CustomText(
              text: toLabelValue(StringConstants.use_this),
              textAlign: TextAlign.center,
              style: TextStyleConfig.boldTextStyle(
                  fontSize: TextStyleConfig.bodyText14,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants().primaryGradient),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetAddress() {
    return mapController.currentAddress != ""
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SvgPicture.asset(
                    ImageConstants.icon_map_pin,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: Get.width * 0.71,
                  child: CustomText(
                    text: mapController.currentAddress != "" ? mapController.currentAddress : "",
                    maxlines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyleConfig.boldTextStyle(
                        fontSize: TextStyleConfig.bodyText16,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants().primaryGradient),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget _widgetMap() {
    return Expanded(
      child: mapController.currentAddress != ""
          ? GoogleMap(
              onMapCreated: mapController.onMapCreated,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              gestureRecognizers: Set()
                ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
                ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer())),
              initialCameraPosition: CameraPosition(
                target: mapController.center!,
                zoom: 17.0,
              ),
              onCameraMove: ((newPosition) {
                if (kDebugMode) {
                  print(newPosition.target.latitude);

                  print(newPosition.target.longitude);
                }
              }),
              onTap: (newPosition) {
                mapController.center = newPosition;
                mapController.update();
                mapController.markers = [];

                mapController.handleTap(LatLng(newPosition.latitude, newPosition.longitude));
              },
              markers: mapController.markers.toSet(),
            )
          : Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: CircularProgressIndicator(
                  color: ColorConstants().primaryGradient,
                ),
              ),
            ),
    );
  }

  Widget _widgetButtonDone() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: PrimaryButton(
        btnTitle: StringConstants.done,
        onClicked: () {
          Get.find<ControllerEditProfile>().selectedLocation.value = mapController.currentAddress;
          Get.find<ControllerEditProfile>().center = mapController.center;

          Get.back();
          Get.find<ControllerEditProfile>().update();
        },
      ),
    );
  }
}
