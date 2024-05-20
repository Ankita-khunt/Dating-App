import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/dashboard/user_detail_model.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/binding_preview.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/controller_preview.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/block_user/binding_block_user.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/block_user/controller_block_user.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/my_boost/bindng_my_boost.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/my_boost/controller_my_boost.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/binding_edit_profile.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/controller_edit_profile.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_gallery/binding_my_gallery.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_gallery/controller_my_gallery.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_likes/binding_my_likes.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_likes/controller_my_likes.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_subscription/binding_my_subscription.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_subscription/controller_my_subscription.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/swipe/binding_swipe.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/swipe/controller_swipe.dart';
import 'package:dating_app/src/widgets/custom_divider.dart';

import '../../../../widgets/widget_custom_switch.dart';
import 'controller_profile.dart';

class ScreenProfile extends StatelessWidget {
  ScreenProfile({super.key});

  final profileController = Get.find<ControllerProfile>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants().white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(58.0),
            child: CustomAppBar(
              isGradientAppBar: true,
              isBackVisible: false,
              title: toLabelValue(StringConstants.my_profile),
              titleColor: ColorConstants().white,
            )),
        body: GetBuilder<ControllerProfile>(
          builder: (controller) {
            return controller.profileresponse != null
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userDetailWidget(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: subscriptionWidget(),
                        ),
                        profileOptionList(),
                        const SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                          child: PlanButton(
                            btnWidth: Get.width,
                            btnTitle: StringConstants.logout,
                            foregroundcolor: ColorConstants().primaryGradient,
                            onClicked: () {
                              profileController.logout();
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            profileController.deleteAccount();
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: CustomText(
                              text: toLabelValue(StringConstants.delete_account),
                              style: TextStyleConfig.boldTextStyle(
                                  color: ColorConstants().primaryGradient,
                                  fontWeight: FontWeight.w700,
                                  fontSize: TextStyleConfig.bodyText14),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16, top: 28),
                          child: Align(
                              alignment: Alignment.center,
                              child: Obx(() {
                                debugPrint(profileController.appVersion.value);
                                return Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: toLabelValue(StringConstants.app_version),
                                        style: TextStyleConfig.boldTextStyle(
                                            color: ColorConstants().grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: TextStyleConfig.bodyText12),
                                      ),
                                      TextSpan(
                                        text: ' ${profileController.appVersion.value}',
                                        style: TextStyleConfig.boldTextStyle(
                                            color: ColorConstants().grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: TextStyleConfig.bodyText12),
                                      ),
                                    ],
                                  ),
                                  maxLines: 3,
                                );
                              })),
                        )
                      ],
                    ),
                  )
                : controller.isDataLoaded.value
                    ? noDataView(StringConstants.no_data_found)
                    : const SizedBox();
          },
        ));
  }

  Widget userDetailWidget() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              BindingPreview().dependencies();
              Get.find<ControllerPreview>().productImages = [
                Images(
                  id: "0",
                  imageUrl: "${profileController.profileresponse?.profileImage!}",
                )
              ];
              Get.toNamed(Routes.preview_image);
            },
            child: Stack(
              children: [
                Obx(() {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 0),
                    ),
                    child: profileController.selectedProfileImage.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.file(
                              profileController.selectedProfileImage.value!,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(
                              '${generalSetting?.s3Url}${profileController.profileresponse?.profileImage!}',
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              errorBuilder: (context, error, stackTrace) {
                                return SvgPicture.asset(ImageConstants.icon_profileUser);
                              },
                            ),
                          ),
                  );
                }),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () async {
                      List<File> pickedImage = await showImageSelectionBottomSheet();
                      profileController.selectedProfileImage.value = pickedImage.first;
                      profileController.updateProfileImageAPI();
                    },
                    child: SvgPicture.asset(ImageConstants.icon_camera, fit: BoxFit.scaleDown),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: profileController.profileresponse?.name,
                  style: TextStyleConfig.boldTextStyle(
                      color: ColorConstants().black, fontWeight: FontWeight.w700, fontSize: TextStyleConfig.bodyText16),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 10),
                  child: CustomText(
                    text: profileController.profileresponse?.email,
                    style: TextStyleConfig.regularTextStyle(
                        color: ColorConstants().black,
                        fontWeight: FontWeight.w400,
                        fontSize: TextStyleConfig.bodyText14),
                  ),
                ),
                InkWell(
                  onTap: () {
                    BindingEditProfile().dependencies();
                    Get.find<ControllerEditProfile>().editProfileResponse = null;
                    Get.find<ControllerEditProfile>().getSetUpProfileAPI();
                    Get.toNamed(Routes.editProfileRoute);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 50, 8),
                    child: CustomText(
                      text: toLabelValue(StringConstants.edit_profile),
                      style: TextStyleConfig.boldTextStyle(
                          color: ColorConstants().primaryGradient,
                          fontWeight: FontWeight.w700,
                          fontSize: TextStyleConfig.bodyText14),
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  subscriptionWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              BindingMyBoost().dependencies();
              Get.find<ControllerMyBoost>().getMyBoostAPI();
              Get.toNamed(Routes.my_boost);
            },
            child: SizedBox(
              width: Get.width * .29,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorConstants().secondaryGradient,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImageConstants.icon_boost,
                      fit: BoxFit.scaleDown,
                      height: 42,
                    ),
                    CustomText(
                      text: toLabelValue(StringConstants.my_boost),
                      style: TextStyleConfig.regularTextStyle(
                          color: ColorConstants().white,
                          fontWeight: FontWeight.w400,
                          fontSize: TextStyleConfig.bodyText14),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomText(
                      text: toLabelValue(StringConstants.get_more),
                      style: TextStyleConfig.regularTextStyle(
                          color: ColorConstants().white,
                          fontWeight: FontWeight.w700,
                          fontSize: TextStyleConfig.bodyText14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              BindingMySwipe().dependencies();
              Get.find<ControllerMySwipe>().getMySwipeAPI();
              Get.toNamed(Routes.my_swipe);
            },
            child: SizedBox(
              width: Get.width * .29,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: ColorConstants().secondaryGradient,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImageConstants.icon_like,
                      height: 42,
                    ),
                    CustomText(
                      text: toLabelValue(StringConstants.swipe),
                      style: TextStyleConfig.regularTextStyle(
                          color: ColorConstants().white,
                          fontWeight: FontWeight.w400,
                          fontSize: TextStyleConfig.bodyText14),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomText(
                      text: toLabelValue(StringConstants.get_more),
                      style: TextStyleConfig.regularTextStyle(
                          color: ColorConstants().white,
                          fontWeight: FontWeight.w700,
                          fontSize: TextStyleConfig.bodyText14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              BindingMySubscription().dependencies();
              Get.find<ControllerMySubscription>().getMySubscriptionAPI();
              Get.toNamed(Routes.my_subscription);
            },
            child: SizedBox(
              width: Get.width * .29,
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
                decoration: BoxDecoration(
                  color: ColorConstants().secondaryGradient,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageConstants.dating_icon,
                      height: 42,
                    ),
                    CustomText(
                      text: toLabelValue(StringConstants.subscriptions),
                      style: TextStyleConfig.regularTextStyle(
                          color: ColorConstants().white,
                          fontWeight: FontWeight.w400,
                          fontSize: TextStyleConfig.bodyText14),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomText(
                      text: toLabelValue(StringConstants.get_more),
                      style: TextStyleConfig.regularTextStyle(
                          color: ColorConstants().white,
                          fontWeight: FontWeight.w700,
                          fontSize: TextStyleConfig.bodyText14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  profileOptionList() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: profileController.profileOptions.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    dense: true,
                    title: CustomText(
                      text: profileController.profileOptions[index],
                      style: TextStyleConfig.regularTextStyle(
                          color: ColorConstants().black,
                          fontWeight: FontWeight.w500,
                          fontSize: TextStyleConfig.bodyText14),
                    ),
                    contentPadding: EdgeInsets.zero,
                    trailing: index == (isUserSubscribe == true ? 5 : 4)
                        ? Obx(() {
                            return CustomSwitch(
                              value: profileController.isHideProfile.value,
                              onChanged: (bool value) {
                                profileController.hideProfile(value);
                              },
                            );
                          })
                        : SvgPicture.asset(
                            ImageConstants.icon_arrow_forward,
                            fit: BoxFit.cover,
                          ),
                    onTap: () {
                      if (isUserSubscribe == true) {
                        if (index == 0) {
                          Get.toNamed(Routes.changePasswordRoute);
                        }
                        if (index == 1) {
                          BindingMyGallery().dependencies();
                          Get.find<ControllerMyGallery>().onInit();
                          Get.find<ControllerMyGallery>().gallaryResponse = null;
                          Get.find<ControllerMyGallery>().isDataLoaded(false);
                          Get.find<ControllerMyGallery>().getMyGalleryAPI();
                          Get.toNamed(Routes.myGalleryRoute);
                        }
                        if (index == 2) {
                          //Navigate to recent View  screen
                          Get.toNamed(Routes.my_recent_view);
                        }
                        if (index == 3) {
                          BindingMyLikes().dependencies();
                          Get.find<ControllerMyLikes>().tabController.index = 0;
                          Get.find<ControllerMyLikes>().selectedTabIndex.value = 0;
                          Get.find<ControllerMyLikes>().getMyLikesAPI(true);
                          Get.toNamed(Routes.myLikesRoute);
                        }
                        if (index == 4) {
                          BindingBlockUser().dependencies();
                          Get.find<ControllerBlockUser>().getblockUserAPI();
                          Get.toNamed(Routes.blockUser);
                        }
                        if (index == 6) {
                          Get.toNamed(Routes.cmsRoute);
                        }
                      } else {
                        if (index == 0) {
                          Get.toNamed(Routes.changePasswordRoute);
                        }
                        if (index == 1) {
                          Get.toNamed(Routes.subscription);
                        }
                        if (index == 2) {
                          BindingMyLikes().dependencies();
                          Get.find<ControllerMyLikes>().tabController.index = 0;

                          Get.find<ControllerMyLikes>().getMyLikesAPI(true);
                          Get.toNamed(Routes.myLikesRoute);
                        }
                        if (index == 3) {
                          BindingBlockUser().dependencies();
                          Get.find<ControllerBlockUser>().getblockUserAPI();
                          Get.toNamed(Routes.blockUser);
                        }
                        if (index == 5) {
                          Get.toNamed(Routes.cmsRoute);
                        }
                      }
                    },
                  ),
                ),
                CustomDivider()
              ],
            );
          },
        ),
      ),
    );
  }
}
