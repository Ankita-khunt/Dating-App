import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/faq_model.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/cms/faqs/controller_faq.dart';

import '../../../../../widgets/custom_searchBar.dart';

class ScreenFaq extends StatelessWidget {
  ScreenFaq({super.key});

  final faqController = Get.find<ControllerFaq>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants().white,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: GetBuilder<ControllerFaq>(
            builder: (controller) {
              return controller.faqs != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        topWidget(),
                        bottomWidget(context),
                      ],
                    )
                  : controller.isDataLoaded.value
                      ? noDataView(StringConstants.no_data_found)
                      : const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget bottomWidget(BuildContext context) {
    return GetBuilder<ControllerFaq>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              CustomText(
                text: toLabelValue(StringConstants.top_categories),
                overflow: TextOverflow.ellipsis,
                style: TextStyleConfig.regularTextStyle(
                  color: ColorConstants().black,
                  fontWeight: FontWeight.w600,
                  fontSize: TextStyleConfig.bodyText16,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              faqController.searchResult.isNotEmpty || faqController.searchController.value.text.isNotEmpty
                  ? faqController.searchResult.isNotEmpty
                      ? Column(
                          children: [
                            for (FaqList item in faqController.searchResult.toList())
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(color: ColorConstants().lightgrey)),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      trailing: SvgPicture.asset(
                                        ImageConstants.icon_arrow_forward,
                                        fit: BoxFit.scaleDown,
                                      ),
                                      title: CustomText(
                                        text: item.question ?? '',
                                        maxlines: 5,
                                        style: TextStyleConfig.regularTextStyle(
                                          color: ColorConstants().black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: TextStyleConfig.bodyText14,
                                        ),
                                      ),
                                      children: <Widget>[
                                        SizedBox(
                                          width: Get.width,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(16.0, 10, 16, 16),
                                            child: CustomText(
                                              text: item.answer ?? '',
                                              textAlign: TextAlign.left,
                                              style: TextStyleConfig.regularTextStyle(
                                                color: ColorConstants().grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: TextStyleConfig.bodyText12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ],
                        )
                      : noDataView(StringConstants.no_data_found)
                  : Column(
                      children: [
                        for (FaqList item in faqController.faqs!.faqList!)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: ColorConstants().lightgrey)),
                              child: Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  trailing: SvgPicture.asset(
                                    ImageConstants.icon_arrow_forward,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  title: CustomText(
                                    text: item.question ?? '',
                                    maxlines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyleConfig.regularTextStyle(
                                      color: ColorConstants().black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: TextStyleConfig.bodyText14,
                                    ),
                                  ),
                                  children: <Widget>[
                                    SizedBox(
                                      width: Get.width,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(16.0, 10, 16, 16),
                                        child: CustomText(
                                          text: item.answer ?? '',
                                          style: TextStyleConfig.regularTextStyle(
                                            color: ColorConstants().grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: TextStyleConfig.bodyText12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CustomText(
                  text: toLabelValue(StringConstants.need_more_help),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleConfig.regularTextStyle(
                    color: ColorConstants().black,
                    fontWeight: FontWeight.w600,
                    fontSize: TextStyleConfig.bodyText16,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorConstants().primaryGradient.withOpacity(.1),
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            handleLaunchCall(faqController.faqs?.contactNumber);
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                ImageConstants.icon_call,
                                fit: BoxFit.scaleDown,
                                height: 42,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: CustomText(
                                  text: toLabelValue(StringConstants.contact_us),
                                  style: TextStyleConfig.regularTextStyle(
                                      color: ColorConstants().black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: TextStyleConfig.bodyText14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorConstants().primaryGradient.withOpacity(.1),
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            openEmail(faqController.faqs?.contactEmail);
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                ImageConstants.icon_email,
                                fit: BoxFit.scaleDown,
                                height: 42,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: CustomText(
                                  text: toLabelValue(StringConstants.email_us),
                                  style: TextStyleConfig.regularTextStyle(
                                      color: ColorConstants().black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: TextStyleConfig.bodyText14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Container topWidget() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorConstants().primaryGradient, ColorConstants().secondaryGradient],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0, 1],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * .074, child: faqAppbar()),
            SizedBox(height: Get.height * .095, child: userNameWidget()),
            SizedBox(height: Get.height * .13, child: searchWidget()),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Padding userNameWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  ImageConstants.dating_icon,
                  height: 44,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: CustomText(
                    text: toLabelValue(StringConstants.faq).toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleConfig.regularTextStyle(
                      color: ColorConstants().white,
                      fontWeight: FontWeight.w600,
                      fontSize: TextStyleConfig.bodyText16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomText(
            text: faqController.faqs?.username,
            style: TextStyleConfig.boldTextStyle(
                color: ColorConstants().white, fontWeight: FontWeight.w600, fontSize: TextStyleConfig.bodyText16),
          ),
        ],
      ),
    );
  }

  PreferredSize faqAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(4.0),
      child: CustomAppBar(
        title: toLabelValue(StringConstants.faqs),
        titleColor: ColorConstants().white,
        backIconColor: ColorConstants().white,
        isBackVisible: true,
      ),
    );
  }

  Padding searchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: toLabelValue(StringConstants.how_can_we_help),
            overflow: TextOverflow.ellipsis,
            style: TextStyleConfig.regularTextStyle(
              color: ColorConstants().white,
              fontWeight: FontWeight.w700,
              fontSize: TextStyleConfig.bodyText20,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomSearchBar(
            controller: faqController.searchController.value,
            isPrimaryIconColor: true,
            hintText: toLabelValue(StringConstants.search_queries_or_error),
            onValueChanged: (value) async {
              faqController.onSearchTextChanged(value);
            },
            onRemoveValue: () {
              faqController.searchController.value.clear();
              faqController.onSearchTextChanged('');
            },
          )
        ],
      ),
    );
  }
}
