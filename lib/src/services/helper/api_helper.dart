import 'dart:convert';
import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as https;

class MapToList {
  final String? name;
  final String? value;

  MapToList({this.name, this.value});
}

class ApiBaseHelper {
  Map<String, String> header = {'username': 'dattingApp', 'password': '0b8c9977e7da0e76b1b084fed8977dd7'};
  var body = <String, dynamic>{};

  final String _baseUrl = "https://andru.com.au/api/";
  static String socketUrl = "ws://apisocket.andru.com.au:8020";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await https.get(Uri.parse(_baseUrl + url), headers: header);
      responseJson = _returnResponse(response, url);
    } on SocketException {
      throw Exception('Failed to load album');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? formdata}) async {
    var responseJson;
    try {
      final response = await https.post(Uri.parse(_baseUrl + url), body: formdata ?? {}, headers: header);
      if (kDebugMode) {
        print("URLs == $url,==\n $formdata ==== Response == $response");
      }

      responseJson = _returnResponse(response, url);
    } catch (error) {
      if (kDebugMode) {
        print("ErrorURL == $url,==\n $formdata");
      }
      hideLoader();
      if (kDebugMode) {
        print("Catch Error:=== $error.");
      }
      throw Exception('Failed to load album');
    }
    return responseJson;
  }

  Future<dynamic> multipart(String url, file, {Map<String, dynamic>? formdata}) async {
    List<MapToList> fields = formdata!.entries.map((entry) => MapToList(name: entry.key, value: entry.value)).toList();
    var responseJson;
    try {
      final request = https.MultipartRequest(
        'POST',
        Uri.parse(_baseUrl + url),
      );
      request.headers.addAll(header);

      for (var field in fields) {
        request.fields[field.name!] = field.value!;
      }
      if (file != "") {
        request.files.add(await https.MultipartFile.fromPath('profile_image', file));
      }

      final response = await request.send();
      final result = await https.Response.fromStream(response);
      responseJson = _returnResponse(result, url);
    } catch (error) {
      hideLoader();
      if (kDebugMode) {
        print("Catch Error:=== $error.");
      }
      throw Exception('Failed to load album');
    }
    return responseJson;
  }
}

dynamic _returnResponse(https.Response response, String url) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      if (kDebugMode) {
        print("responseJson==== $responseJson");
      }
      // print((responseJson);
      return responseJson;
    case 400:
      hideLoader();
      throw showDialogBox(
        Get.overlayContext!,
        "",
      );
    case 401:
      hideLoader();
      throw Exception(response.body.toString());
    case 403:
      hideLoader();

      throw Exception(response.body.toString());
    case 500:
      hideLoader();
      if (kDebugMode) {
        print("500 Error with url ==== ${url.toString()}");
      }
      throw Exception(response.body.toString());
    default:
      hideLoader();
      if (kDebugMode) {
        print("Error with url ==== ${url.toString()}");
      }

      throw Exception('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
