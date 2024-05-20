import 'package:dating_app/imports.dart';

class GetVideoChatDetailsResponseModel extends Serializable {
  String? appId;
  String? channelId;
  String? timeStamp;

  GetVideoChatDetailsResponseModel(
      {this.appId, this.channelId, this.timeStamp});

  GetVideoChatDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    channelId = json['channel_id'];
    timeStamp = json['time_stamp'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_id'] = appId;
    data['channel_id'] = channelId;
    data['time_stamp'] = timeStamp;
    return data;
  }
}
