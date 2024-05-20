import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/cms_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/cms_webservice.dart';

class ControllerCMS extends GetxController {
  List<String> cmsList = [
    toLabelValue(StringConstants.about_us),
    toLabelValue(StringConstants.faqs),
    toLabelValue(StringConstants.terms_and_conditions),
    toLabelValue(StringConstants.privacy_policy),
    toLabelValue(StringConstants.contact_us)
  ];
  RxBool isDataLoaded = false.obs;

  CMSResponse? cmsResponse;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  //CMS API
  cmsAPI(String cmsID) async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<CMSResponse>? response = await CMSRepository().getCMS(cmsID);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      cmsResponse = response.result;
      Get.toNamed(Routes.cmsDetailsRoute);
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }
}

class CMSModel {
  final String? title;
  final String? description;

  CMSModel({this.title, this.description});
}
