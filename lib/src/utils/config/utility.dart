//Lable key Fetch

// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:dating_app/imports.dart';
import 'package:dating_app/src/widgets/download_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

//Labels
String toLabelValue(
  String key,
) {
  var str = "";

  for (var element in labelList) {
    if (element.key.toString().removeAllWhitespace == key.removeAllWhitespace) {
      str = element.value!;
    }
  }
  return str;
}

/// File Download
Future<void> downloadFile(String url) async {
  showLoader();
  DownloadService downloadService = kIsWeb ? WebDownloadService() : MobileDownloadService();

  final file = await openFile(url: url, filename: url.split("/").last.toString());

  if (file == null) return;

  if (kDebugMode) {
    print("path: ${file.path}");
  }

  hideLoader();
  OpenAppFile.open(file.path);
}

formattedTime({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute : $second";
}

Future<File?> openFile({required String url, required String filename}) async {
  final appStorage = await getApplicationDocumentsDirectory();
  final file = File("${appStorage.path}/$filename");

  try {
    final response = await Dio().get(
      url,
      options: Options(responseType: ResponseType.bytes, followRedirects: false, receiveTimeout: 0),
      onReceiveProgress: (count, total) {
        if (total != -1) {
          if (kDebugMode) {
            print("running ===> ${(count / total * 100).toStringAsFixed(0)}%");
          }

          //you can build progressbar feature too
        }
      },
    );

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return null;
  }
}

// Alert dialogue
showDialogBox(BuildContext context,
    [String? message,
    VoidCallback? onClicked,
    String btnTitle = 'ok',
    VoidCallback? onSecondbtnClicked,
    String secondbtnTitle = '',
    String? title]) {
  hideLoader();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: CustomDialogBox(
            title: title ?? "Dating",
            subtitle: message,
            firstBtnTitle: btnTitle,
            onClickedfirstbtn: onClicked ??
                () {
                  if ((message == toLabelValue(StringConstants.INVALID_TOKEN))) {
                    logoutUser(context);
                  } else if (message == toLabelValue(StringConstants.inactive_account)) {
                    logoutUser(context);
                  } else if (message == toLabelValue(StringConstants.user_delete_account)) {
                    logoutUser(context);
                  } else {
                    Get.back();
                  }
                },
            secondBtnTitle: secondbtnTitle,
            onClickedsecondbtn: onSecondbtnClicked ??
                () {
                  Get.back();
                },
          ),
        ),
      );
    },
  );
}

//UPLOAD IMAGE TO S#BUCKET
uploadS3Image(File imgName) {
  return AwsS3.uploadFile(
      accessKey: generalSetting!.s3AccessKey!,
      secretKey: generalSetting!.s3SecretAccessKey!,
      file: imgName,
      bucket: generalSetting!.s3BucketName!,
      region: generalSetting!.s3Region!,
      contentType: "image/${imgName.path.split("/").last.split(".").last}");
}

/// No Data View
Widget noDataView(
  String msg, [
  String? msg1,
]) =>
    Center(
      child: SizedBox(
        height: 50,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: toLabelValue(msg),
                textAlign: TextAlign.center,
                textScaleFactor: 1.0,
                style: TextStyleConfig.boldTextStyle(
                    color: ColorConstants().grey.withOpacity(0.5), fontSize: TextStyleConfig.bodyText14),
              ),
              const SizedBox(
                height: 5,
              ),
              if (msg1 != null)
                CustomText(
                  text: toLabelValue(msg1),
                  textScaleFactor: 1.0,
                  style: TextStyleConfig.boldTextStyle(
                      color: ColorConstants().grey.withOpacity(0.5), fontSize: TextStyleConfig.bodyText14),
                ),
            ],
          ),
        ),
      ),
    );

/// LogOut
logoutUser(context) async {
  try {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    hideLoader();
    SharedPref.removekeysFromPref(PreferenceConstants.token);
    SharedPref.removekeysFromPref(PreferenceConstants.islogin);
    Get.offAllNamed(Routes.login);
  } catch (error) {
    if (kDebugMode) {
      print(error.toString());
    }
  }
}

//get time to days conversion
extension DateTimeExtension on DateTime {
  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return "just now";
    }
  }
}

//get time to days conversion
extension DateTimeTodayExtension on DateTime {
  String timeAgoTodayFormate({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else {
      return '';
    }
  }
}

dismissKeyboard() {
  FocusManager.instance.primaryFocus!.unfocus();
}

//SnackBar Show/hides
showSnackBar(context, String message, {bool isErrorMessage = true, Duration? duration}) {
  try {
    dismissSnackBar();

    Get.snackbar(
      "",
      "",
      snackPosition: SnackPosition.BOTTOM,
      titleText: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: CustomText(
              text: message.toLowerCase().capitalizeFirst,
              style: TextStyleConfig.boldTextStyle(fontSize: 16, color: ColorConstants().white))),
      padding: const EdgeInsets.all(0),
      backgroundColor: ColorConstants().primaryGradient,
      borderRadius: 20,
      backgroundGradient:
          LinearGradient(colors: [ColorConstants().primaryGradient, ColorConstants().secondaryGradient]),
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: duration ?? const Duration(seconds: 2),
      isDismissible: true,
      dismissDirection: DismissDirection.down,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  } catch (error) {
    if (kDebugMode) {
      print(error.toString());
    }
  }
}

dismissSnackBar() {
  try {
    Get.closeCurrentSnackbar();
    Get.closeAllSnackbars();
  } catch (error) {
    if (kDebugMode) {
      print(error.toString());
    }
  }
}

showLoader() {
  Loader.show(Get.overlayContext!,
      isSafeAreaOverlay: true,
      isBottomBarOverlay: true,
      overlayFromBottom: 0,
      overlayColor: Colors.white60,
      progressIndicator: LoadingAnimationWidget.staggeredDotsWave(color: ColorConstants().primaryGradient, size: 50),
      themeData: Theme.of(Get.overlayContext!)
          .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ColorConstants().primaryLight)));
}

hideLoader() {
  Loader.hide();
}

formatedTimeInMin({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return minute;
}

formatedTimeInSec({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return second;
}

String dateformate(String date, format) {
  //"MMM dd, yyyy"
  var formateddate = DateFormat(format).format(DateTime.parse(date).toLocal());
  return formateddate;
}

//DATE SELECTION INPUT FORMATTER

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = '${cText.substring(0, 2)}/';
      } else {
        // Insert / char
        cText = '${cText.substring(0, pLen)}/${cText.substring(pLen, pLen + 1)}';
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = '${cText.substring(0, 5)}/';
      } else {
        // Insert / char
        cText = '${cText.substring(0, 5)}/${cText.substring(5, 6)}';
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

/// Get path extension For image Display
getImage(String path) {
  final extension = p.extension(path);

  switch (extension) {
    case '.doc':
    case '.docx':
      return ImageConstants.doc;
    case '.pdf':
      return ImageConstants.pdf;

    default:
      return ImageConstants.doc;
  }
}

//IMAGE SELECT FROM GALLERY/CAMERA
showImageSelectionBottomSheet() {
  return showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    context: Get.overlayContext!,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        height: MediaQuery.of(context).size.height * 0.26,
        decoration: BoxDecoration(
          color: ColorConstants().white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: toLabelValue(StringConstants.choose_option.tr),
              style: TextStyleConfig.boldTextStyle(
                fontSize: TextStyleConfig.bodyText14,
                color: ColorConstants().black,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(width: 15),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        var pickedImage = await imgForProfile(ImageSource.camera);
                        Navigator.of(context).pop([pickedImage]);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            size: 40,
                            Icons.camera,
                            color: ColorConstants().primaryGradient,
                          ),
                          CustomText(
                            textAlign: TextAlign.center,
                            text: toLabelValue(StringConstants.camera.tr),
                            style: TextStyleConfig.regularTextStyle(
                              fontSize: TextStyleConfig.bodyText14,
                              color: ColorConstants().black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      var pickedImage = await imgForProfile(ImageSource.gallery);
                      Navigator.of(context).pop([pickedImage]);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.filter,
                          size: 35,
                          color: ColorConstants().primaryGradient,
                        ),
                        const SizedBox(height: 5),
                        CustomText(
                          textAlign: TextAlign.center,
                          text: toLabelValue(StringConstants.gallery.tr),
                          style: TextStyleConfig.regularTextStyle(
                            fontSize: TextStyleConfig.bodyText14,
                            color: ColorConstants().black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ],
        ),
      );
    },
  );
}

/// Remove special character From String
removeSpecialCharacters(String value) {
  final output = value.replaceAll(r"$", '');
  return output;
}

/// Currency Formatter
currencyFormatter(String value) {
  MoneyFormatter fmf = MoneyFormatter(amount: double.parse(removeSpecialCharacters(value)));
  return fmf.output.withoutFractionDigits;
}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

Future<File> imgForProfile(ImageSource source) async {
  File? profileimage;
  final picker = ImagePicker();

  try {
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 30,
    );
    String sizes = formatBytes(File(pickedFile!.path).readAsBytesSync().length, 2);
    var sizedata = sizes.split(' ');
    var extension = pickedFile.path.split('.');

    if (extension.last.toLowerCase() == 'pdf' ||
        extension.last.toLowerCase() == 'doc' ||
        extension.last.toLowerCase() == 'docx' ||
        extension.last.toLowerCase() == 'jpg' ||
        extension.last.toLowerCase() == 'png' ||
        extension.last.toLowerCase() == 'jpeg' ||
        extension.last.toLowerCase() == 'heic') {
      if (double.parse(sizedata[0]) > double.parse('8') && (sizedata[1] == 'MB')) {
        showDialogBox(Get.overlayContext!, StringConstants.file_size_validation);
      } else {
        profileimage = File(pickedFile.path);
      }
    } else {
      Get.back();
      showDialogBox(Get.overlayContext!, toLabelValue(StringConstants.file_type_validation));
    }
  } catch (error) {
    openSettingsSelectionDialog(Get.overlayContext!, error);
    if (kDebugMode) {
      print(error.toString());
    }
  }
  return profileimage!;
}

openSettingsSelectionDialog(BuildContext context, Object e) {
  if (e is PlatformException) {
    return showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const CustomText(
            text: 'You need to enable required permissions for the app to work correctly.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            CupertinoButton(
              onPressed: () async {
                Get.back();
              },
              child: const Text('Close'),
            ),
            CupertinoButton(
              onPressed: () async {
                Get.back();
                openAppSettings();
              },
              child: const Text('settings'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> openSettingsDialog(BuildContext context) {
  return showCupertinoDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const CustomText(
          text:
              'We need access to your location to provide your current location. To enable locatison services, please enable location from setting.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            onPressed: () async {
              Get.back();
              openAppSettings();
            },
            child: Text(toLabelValue(StringConstants.open_setting)),
          ),
        ],
      );
    },
  );
}

openEmail(String? emailAddress) async {
  EmailContent email = EmailContent(
    to: [emailAddress ?? 'andruptyltd@gmail.com'],
  );

  OpenMailAppResult result =
      await OpenMailApp.composeNewEmailInMailApp(nativePickerTitle: 'Select email app to compose', emailContent: email);
  if (!result.didOpen && !result.canOpen) {
    showDialog(
      context: Get.overlayContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Open Mail App"),
          content: const Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  } else if (!result.didOpen && result.canOpen) {
    showDialog(
      context: Get.overlayContext!,
      builder: (_) => MailAppPickerDialog(
        mailApps: result.options,
        emailContent: email,
      ),
    );
  }
}

Future handleLaunchCall(dynamic data) async {
  try {
    if (data is String) {
      final Uri callLaunchUri = Uri(
        scheme: 'tel',
        path: data,
      );

      await launchUrl(Uri.parse(callLaunchUri.toString()));
    }
  } on Exception {}
}

Future<DateTime?> dobDatePicker(context, selectedDate) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
    firstDate: DateTime(1900),
    lastDate: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
            primaryColor: ColorConstants().primaryGradient,
            colorScheme: ColorScheme.light(primary: ColorConstants().primaryGradient),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            dialogTheme:
                const DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))))),
        child: child!,
      );
    },
  );
  return pickedDate;
}

formate_yyyyMMdd(String date) {
  var inputFormat = DateFormat('dd/MM/yyyy');
  var date1 = inputFormat.parse(date);

  var outputFormat = DateFormat('yyyy-MM-dd');
  var date2 = outputFormat.format(date1);
  return date2;
}

//WEBsocket for online offline
connectWebsocket() {
  try {
    socket = IO.io(ApiBaseHelper.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket?.connect();
    socket?.onConnect((_) {
      print('Connection established');
      sendMessage("online");
    });
    socket?.onDisconnect((_) {
      if (kDebugMode) {
        print('Connection Disconnection');
      }
    });

    socket?.onConnectError((err) => print(err));
    socket?.onError((err) => print(err));
  } catch (e) {
    print(e);
  }
}

sendMessage(String key) async {
  try {
    String userID = await SharedPref.getString(PreferenceConstants.userID);

    Map messageMap = {
      'user_id': userID,
    };

    socket?.emit(key, messageMap);

    print("KEY ==== > ${key}");
  } on Exception catch (e) {
    print(" ==> err  $e");
    // TODO
  }
}

//Error icon for cached image
Center errorImage() {
  return Center(
    child: Image.asset(
      ImageConstants.dating_icon,
      color: ColorConstants().primaryGradient,
    ),
  );
}
