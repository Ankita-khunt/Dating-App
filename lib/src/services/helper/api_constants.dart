const int CODE_SUCCESS = 200;
const int CODE_FAILURE = 101;
const int CODE_UNAUTHORIZATION = 401;
const int CODE_RESOURCE_GONE = 410;
const int CODE_BAD_REQUEST = 400;
const int CODE_ACCOUNT_INACTIVE = 400;
const int CODE_SERVER_ERROR = 500;

const int CODE_SOMETHING_WENT_WRONG = 0;
const int CODE_INVALID_EMAIL = 3;
const int CODE_INVALID_PASSWORD = 4;
const int CODE_UNAUTHORIZED = -1;
const int CODE_SUCCESS_CODE = 1;

//API Constants
class APIConstants {
  static const String label_endpoint = 'labels';
  static const String general_endpoint = "general";
  static const String register_endpoint = "register";
  static const String login_endpoint = "login";
  static const String username_exists_endpoint = "username_exists";
  static const String get_set_up_profile_endpoint = "get_set_up_profile";
  static const String update_setup_profile_endpoint = "update_setup_profile";
  static const String user_card_list_endpoint = "user_card_list";
  static const String user_like_endpoint = "user_like";
  static const String notification_list_endpoint = "notification_list";
  static const String get_user_details_endpoint = "get_user_details";
  static const String logout_endpoint = "logout";
  static const String cms_endpoint = "cms";
  static const String faqs_endpoint = "faqs";
  static const String contact_us_endpoint = "contact_us";
  static const String get_match_list_endpoint = "get_match_list";
  static const String remove_match_endpoint = "remove_match";

  static const String get_profile_endpoint = "get_profile";
  static const String get_edit_profile_data_endpoint = "get_edit_profile_data";
  static const String hide_profile_endpoint = "hide_profile";
  static const String delete_account_endpoint = "delete_account";
  static const String update_edit_profile_endpoint = "update_edit_profile";
  static const String change_password_endpont = "change_password";
  static const String end_boost_endpont = "end_boost";
  static const String boost_purchase_plan_endpont = "boost_purchase_plan";
  static const String swipe_purchase_plan_endpont = "swipe_purchase_plan";

  static const String upload_profile_image_endpont = "upload_profile_image";
  static const String get_block_users_endpont = "get_block_users";

  static const String my_likes_endpont = "my_likes";
  static const String get_my_gallery_endpont = "get_my_gallery";
  static const String bloc_user_endpont = "bloc_user";
  static const String report_user_endpont = "report_user";
  static const String forgot_password_endpont = "forgot_password";
  static const String reset_password_endpont = "reset_password";
  static const String updalod_gallery_photo_endpont = "updalod_gallery_photo";
  static const String remove_gallary_photo_endpont = "remove_gallary_photo";
  static const String subscription_plan_endpont = "subscription_plan";
  static const String get_my_subscription_endpont = "get_my_subscription";
  static const String get_boost_data_endpont = "get_boost_data";
  static const String get_history_endpont = "get_history";
  static const String boost_profile_endpont = "boost_profile";
  static const String get_boost_time_endpont = "get_boost_time";
  static const String get_chat_list_endpont = "get_chat_list";
  static const String get_user_chat_endpont = "get_user_chat";
  static const String send_message_endpont = "send_message";
  static const String my_recent_view_endpoint = "recent_views";
  static const String get_video_chat_details = "get_video_chat_details";
  static const String get_swipe_data_details = "get_swipe_data";
  static const String purchase_plan_details = "purchase_plan";

  static const String check_user_status_endpoint = "check_user_status";
  static const String decline_call_api = "decline_video_call";
  static const String get_decline_call_api = "get_decline_call";
}
