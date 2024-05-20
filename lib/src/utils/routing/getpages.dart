import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/authentication/create_new_password/screen_createnew_pass.dart';
import 'package:dating_app/src/screen/authentication/forgotpass/binding_forgotpassword.dart';
import 'package:dating_app/src/screen/authentication/forgotpass/screen_forgotpassword.dart';
import 'package:dating_app/src/screen/authentication/login/binding_login.dart';
import 'package:dating_app/src/screen/authentication/register/binding_register.dart';
import 'package:dating_app/src/screen/authentication/register/screen_register.dart';
import 'package:dating_app/src/screen/authentication/register/success_register/screen_createAcc_success.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/binding_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/screen_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/chat/videocall/screen_video_call.dart';
import 'package:dating_app/src/screen/dashboard/custom_tab/binding/binding_tabbar.dart';
import 'package:dating_app/src/screen/dashboard/custom_tab/view/bottom_navigation.dart/bottom_navigation.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/binding_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/filter/binding_filter.dart';
import 'package:dating_app/src/screen/dashboard/home/filter/screen_filter.dart';
import 'package:dating_app/src/screen/dashboard/home/notification/binding_notification.dart';
import 'package:dating_app/src/screen/dashboard/home/notification/screen_notification.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/binding_preview.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/screen_preview_image.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/screen_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/binding_match.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/screen_match.dart';
import 'package:dating_app/src/screen/dashboard/matches/match_detail/binding_matchDetail.dart';
import 'package:dating_app/src/screen/dashboard/matches/match_detail/screen_matchDetail.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/block_user/screen_block_user.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/boost_history/binding_boost_history.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/boost_history/screen_boost_history.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/my_boost/bindng_my_boost.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/my_boost/screen_my_boost.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/change_password/binding_change_password.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/change_password/screen_change_password.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/cms/binding_cms.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/cms/faqs/binding_faq.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/cms/screen_cms.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/binding_edit_profile.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/mapView/binding_mapview.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/mapView/screen_mapView.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/screen_edit_profile.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/screen_physical_information.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_gallery/binding_my_gallery.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_recent_view/my_recent_view_binding.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_recent_view/my_recent_view_screen.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_subscription/binding_my_subscription.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_subscription/screen_my_subscription.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/profile/binding_profile.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/profile/screen_profile.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/swipe/binding_swipe.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/swipe/screen_swipe.dart';
import 'package:dating_app/src/screen/onbording/onbording_screen/binding_onboard.dart';
import 'package:dating_app/src/screen/setupprofile/binding_setup_profile.dart';
import 'package:dating_app/src/screen/setupprofile/screen_setup_profile.dart';
import 'package:dating_app/src/screen/setupprofile/setup_profile_success/screen_profile_setup_success.dart';
import 'package:dating_app/src/screen/subscriptions/binding_subscription.dart';
import 'package:dating_app/src/screen/subscriptions/screen_subscription.dart';

import '../../screen/dashboard/my_profile/cms/contact_us/binding_contact_us.dart';
import '../../screen/dashboard/my_profile/cms/contact_us/screen_contact_us.dart';
import '../../screen/dashboard/my_profile/cms/faqs/screen_faq.dart';
import '../../screen/dashboard/my_profile/cms/screen_cms_detail.dart';
import '../../screen/dashboard/my_profile/my_gallery/screen_my_gallery.dart';
import '../../screen/dashboard/my_profile/my_likes/binding_my_likes.dart';
import '../../screen/dashboard/my_profile/my_likes/screen_my_likes.dart';

List<GetPage> getPages = [
  GetPage(
    name: Routes.splash,
    page: () => ScreenSplash(),
    bindings: [BindingSplash()],
  ),
  GetPage(
      name: Routes.customTabbar,
      page: () => CustomTabbar(),
      bindings: [TabbarBinding(), BindingCard()],
      transition: Transition.noTransition),
  GetPage(
    name: Routes.connctionbar,
    page: () => const ConnectionStatusBars(),
  ),
  GetPage(name: Routes.notification, page: () => ScreenNotification(), binding: BindingNotification()),
  GetPage(
    name: Routes.setupprofileSuccess,
    page: () => ScreenSuccessProfileSetUP(),
  ),
  GetPage(
    name: Routes.onboard1,
    page: () => ScreenOnboard1(),
    binding: BindingOnboard(),
  ),
  GetPage(
    name: Routes.onboard2,
    page: () => const ScreenOnboard2(),
  ),
  GetPage(
    name: Routes.blockUser,
    page: () => ScreenBlockUser(),
  ),
  GetPage(
    name: Routes.login,
    binding: BindingLogin(),
    page: () => ScreenLogin(),
  ),
  GetPage(
    name: Routes.forgotpass,
    bindings: [
      BindingForgotPassword(),
    ],
    page: () => ScreenForgotPassword(),
  ),
  GetPage(
    name: Routes.createnewpass,
    page: () => ScreenCreateNewPassword(),
  ),
  GetPage(
    name: Routes.register,
    bindings: [
      BindingRegister(),
    ],
    page: () => ScreenRegister(),
  ),
  GetPage(
    name: Routes.registerSuccess,
    page: () => const ScreenSuccessAccCreate(),
  ),
  GetPage(
    name: Routes.setupprofile,
    binding: BindingSetUpProfile(),
    page: () => ScreenSetupProfile(),
  ),
  GetPage(
    name: Routes.subscription,
    binding: BindingSubscription(),
    page: () => ScreenSubscription(),
  ),
  GetPage(
    name: Routes.profileRoute,
    binding: BindingProfile(),
    page: () => ScreenProfile(),
  ),
  GetPage(
    name: Routes.editProfileRoute,
    binding: BindingEditProfile(),
    page: () => ScreenEditProfile(),
  ),
  GetPage(
      name: Routes.mapview, binding: BindingMapView(), page: () => ScreenMapView(), transition: Transition.downToUp),
  GetPage(
      name: Routes.physical_information,
      binding: BindingEditProfile(),
      page: () => ScreenPhysicalInformation(),
      transition: Transition.downToUp),
  GetPage(
    name: Routes.cmsRoute,
    binding: BindingCMS(),
    page: () => ScreenCMS(),
  ),
  GetPage(
    name: Routes.cmsDetailsRoute,
    page: () => ScreenCMSDetails(),
  ),
  GetPage(
    name: Routes.faqRoute,
    binding: BindingFaq(),
    page: () => ScreenFaq(),
  ),
  GetPage(
    name: Routes.contactUsRoute,
    binding: BindingContactUs(),
    page: () => ScreenContactUs(),
  ),
  GetPage(
    name: Routes.changePasswordRoute,
    binding: BindingChangePassword(),
    page: () => ScreenChangePassword(),
  ),
  GetPage(
    name: Routes.filter,
    binding: BindingFilter(),
    page: () => ScreenFilter(),
  ),
  GetPage(
    name: Routes.myGalleryRoute,
    binding: BindingMyGallery(),
    page: () => ScreenMyGallery(),
  ),
  GetPage(
    name: Routes.myLikesRoute,
    binding: BindingMyLikes(),
    page: () => ScreenMyLikes(),
  ),
  GetPage(
    name: Routes.user_detail,
    // binding: BindingUserdetail(),
    page: () => ScreenUserDetail(),
  ),
  GetPage(
    name: Routes.preview_image,
    binding: BindingPreview(),
    page: () => ScreenPreview(),
  ),
  GetPage(
    name: Routes.match,
    binding: BindingMatch(),
    page: () => ScreenMatch(),
  ),
  GetPage(
    name: Routes.matchDetail,
    binding: BindingMatchDetail(),
    page: () => ScreenMatchDetail(),
  ),
  GetPage(
    name: Routes.videocall,
    page: () => const ScreenVideoCall(),
  ),
  GetPage(
    name: Routes.my_boost,
    binding: BindingMyBoost(),
    page: () => ScreenMyBoost(),
  ),
  GetPage(
    name: Routes.chat_detail,
    binding: BindingChatDetail(),
    page: () => ScreenChatDetail(),
  ),
  GetPage(
    name: Routes.my_subscription,
    binding: BindingMySubscription(),
    page: () => ScreenMySubscription(),
  ),
  GetPage(
    name: Routes.boost_history,
    binding: BindingBoostHistory(),
    page: () => const ScreenBoostHistory(),
  ),
  GetPage(
    name: Routes.my_recent_view,
    binding: MyRecentViewBinding(),
    page: () => MyRecentViewScreen(),
  ),
  GetPage(
    name: Routes.my_swipe,
    binding: BindingMySwipe(),
    page: () => ScreenMySwipe(),
  ),
];
