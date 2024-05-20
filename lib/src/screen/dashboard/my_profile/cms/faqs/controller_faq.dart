import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/faq_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/cms_webservice.dart';

class ControllerFaq extends GetxController with GetTickerProviderStateMixin {
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxBool isDataLoaded = false.obs;
  FAQResponse? faqs;
  List<FaqList> searchResult = [];

  //FAQs API
  faqsAPI() async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<FAQResponse>? response = await CMSRepository().getFAQ();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      faqs = response.result;
      Get.toNamed(Routes.faqRoute);

      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }

  //Search faqs
  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      update();
      return;
    }

    for (var faq in faqs!.faqList!) {
      if (faq.question!.toLowerCase().contains(text.toLowerCase()) ||
          faq.answer!.toLowerCase().contains(text.toLowerCase())) {
        searchResult.add(faq);
      }
    }

    update();
  }
}
