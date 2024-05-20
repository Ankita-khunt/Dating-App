import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/setup_profile_model.dart';
import 'package:dating_app/src/model/dashboard/user_detail_model.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/setupprofile/controller_setup_profile.dart';
import 'package:dating_app/src/services/repository/authentication_webservice/setup_profile_webservice.dart';
import 'package:dating_app/src/services/repository/dashboard_webservice/get_user_detail.dart';
import 'package:dating_app/src/services/repository/profile_webservice/block_users_webservice.dart';

class ControllerUserDetail extends GetxController {
  final pageController = PageController();
  final currentPageNotifier = ValueNotifier<int>(0);
  UserDetailResponse? userdata;
  GetSetUpProfileResponse? getSetupProfile;

  TextEditingController reportMsgController = TextEditingController();
  RxBool isDataLoaded = false.obs;
  RxBool isIncognitoModeON = false.obs;
  RxBool isShowLikeButtom = true.obs;

//pageView Index
  List<SelectedStep> steps = [];
  RxInt selectedStepIndex = 1.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  buildPageView() {
    return PageView.builder(
      itemCount: 1,
      controller: pageController,
      itemBuilder: (BuildContext context, int index) {
        return CachedNetworkImage(
          imageUrl: "${generalSetting?.s3Url}${userdata!.profile.toString()}",
          fit: BoxFit.cover,
          width: Get.width,
          alignment: Alignment.topCenter,
          height: Get.height,
          errorWidget: (context, url, error) => Image.asset(ImageConstants.noimage),
        );
      },
      onPageChanged: (int index) {
        currentPageNotifier.value = index;

        if (selectedStepIndex.value > index) {
          if (selectedStepIndex.value > 1) {
            selectedStepIndex.value -= 1;

            steps[selectedStepIndex.value].isSelected = false;
          }
        } else {
          selectedStepIndex.value = index;
          steps[selectedStepIndex.value].isSelected = true;
          selectedStepIndex += 1;
        }
        update();
      },
    );
  }

  Future<void> getSetUpProfileAPI() async {
    ApiResponse<GetSetUpProfileResponse>? response = await SetupProfileRepository().getSetupProfile();
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      getSetupProfile = response.result;

      update();
      hideLoader();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

//Get USERDETAIL API
  Future<void> getUserDetailAPI(String cardID, lat, long, isIncognitoMode) async {
    isUserSubscribe = await SharedPref.getBool(PreferenceConstants.isUserSubscribed);

    if (!isDataLoaded.value) showLoader();

    ApiResponse<UserDetailResponse>? response =
        await UserDetailRepository().getUserDetail(cardID, lat, long, isIncongnitoMode: isIncognitoMode);
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      hideLoader();

      userdata = response.result!;

      if (userdata!.images!.isNotEmpty) {
        steps = List.generate(
            userdata!.images!.length, (index) => SelectedStep(step: index, isSelected: index == 0 ? true : false));
      } else {
        steps = List.generate(1, (index) => SelectedStep(step: index, isSelected: index == 0 ? true : false));
      }
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded.value = true;

    hideLoader();
    update();
  }

//Dialogue for  Report Block
  blockUserDialogue(String blockuserID, isBlock, username) {
    showDialogBox(
      Get.overlayContext!,
      "${toLabelValue(StringConstants.are_you_sure_want_to_block)} $username?",
      () {
        Get.back();
      },
      StringConstants.no,
      () {
        Get.back();
        blockUserAPI(blockuserID, isBlock);
      },
      StringConstants.yes,
    );
  }

  //Block API
  Future<void> blockUserAPI(String blockuserID, String isBlock) async {
    showLoader();

    ResponseModel? response = await BlockUserRepository().blockUser(blockuserID, isBlock);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      hideLoader();

      Get.find<ControllerCard>().update();
      if (isBlock == "1") {
        Get.find<ControllerCard>().cardlist.removeWhere(
              (element) => element.id == blockuserID,
            );
      }

      Get.find<ControllerCard>().update();
      Future.delayed(
        const Duration(milliseconds: 0),
        () {
          Get.back();
        },
      );
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }

  show_report_dialogue(String reportuserID) {
    return Get.bottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ), StatefulBuilder(
      builder: (BuildContext bottomContext, StateSetter setState) {
        return SafeArea(
          child: PopScope(
            canPop: true,
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(bottomContext).size.height * 0.38,
                  minHeight: MediaQuery.of(bottomContext).size.height * 0.26),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )),
              child: SafeArea(
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: SvgPicture.asset(
                          ImageConstants.icon_grey_indicator,
                          height: 5,
                          fit: BoxFit.scaleDown,
                        )),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 32, 0, 4),
                            child: CustomText(
                              text: toLabelValue(StringConstants.report_user),
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  fontSize: TextStyleConfig.bodyText16, color: ColorConstants().black),
                            ),
                          ),
                        ),
                        CustomText(
                          text: toLabelValue(StringConstants.message),
                          textAlign: TextAlign.center,
                          style: TextStyleConfig.regularTextStyle(
                              fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
                        ),
                        SizedBox(
                            height: 150,
                            child: CustomTextfieldWidget(
                              controller: reportMsgController,
                              borderRadius: 16,
                              inputformater: [NoLeadingSpaceFormatter()],
                              placeholder: toLabelValue(StringConstants.enter_message),
                              contentPadding: const EdgeInsets.only(left: 4, bottom: 4, top: 20, right: 4),
                              maxLines: 8,
                            )),
                        const SizedBox(
                          height: 16,
                        ),
                        PrimaryButton(
                          btnTitle: StringConstants.send,
                          onClicked: () {
                            validateReportField(userdata!.cardID!);
                          },
                        )
                      ],
                    )),
              ),
            ),
          ),
        );
      },
    ));
  }

  validateReportField(String cardID) {
    String isValidatemsg = Validator.blankValidation(reportMsgController.text, StringConstants.message);

    if (isValidatemsg != "") {
      showSnackBar(Get.overlayContext, isValidatemsg);
    } else {
      reportUserAPI(cardID, reportMsgController.text);
    }
  }

  //Report API
  reportUserAPI(String reportuserID, String msg) async {
    showLoader();

    ResponseModel? response = await BlockUserRepository().reportUser(reportuserID, msg);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      hideLoader();
      reportMsgController.text = "";
      Get.back();
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }
}
