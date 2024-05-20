import 'package:permission_handler/permission_handler.dart';

abstract class DownloadService {
  Future<void> download({required String url});
}

class WebDownloadService implements DownloadService {
  @override
  Future<void> download({required String url}) async {}
}

class MobileDownloadService implements DownloadService {
  @override
  Future<void> download({required String url}) async {
    url = "https://fluttercampus.com/sample.pdf";
  }

  // requests storage permission
  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }
}
