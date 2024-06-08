import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:multitrip_user/api/app_exceptions.dart';

class ApiBaseHelper {
  final String _baseUrl = "https://webpristine.com/Dispatch-app/v1/api/";

  Future<dynamic> get(
    String url,
  ) async {
    debugPrint('Api Get, url $url');
    dynamic responseJson;
    try {
      final response = await http.get(
        Uri.parse(
          _baseUrl + url,
        ),
      );
      responseJson = _returnResponse(
        response,
      );
    } on SocketException {
      debugPrint('No net');
      throw FetchDataException(
        message: 'No Internet connection',
      );
    }
    debugPrint(
      'api get recieved!',
    );
    return responseJson;
  }

  Future<dynamic> post(
    String url,
    dynamic body,
    Map<String, String>? headers,
  ) async {
    debugPrint(
      'Api Post, url $url',
    );
    debugPrint(
      'Api Post, headers $headers',
    );
    debugPrint(
      'Api Post, body $body',
    );
    dynamic responseJson;
    try {
      final response = await http
          .post(
              Uri.parse(
                _baseUrl + url,
              ),
              body: body,
              headers: headers)
          .timeout(
            Duration(
              seconds: 7,
            ),
          );
      debugPrint(response.body);
      responseJson = _returnResponse(
        response,
      );
    } on SocketException {
      debugPrint('No net');
      throw FetchDataException(
        message: 'No Internet connection',
      );
    } on TimeoutException {
      if (Loader.isShown) {
        Loader.hide();
      }
    }
    debugPrint(
      'api post.',
    );
    return responseJson;
  }

  Future<dynamic> uploadImage(
    String url,
    Map body,
    String filePath,
    Map<String, String>? headers,
  ) async {
    debugPrint(
      'Api Post, url $url',
    );
    dynamic responseJson;
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + 'update_customer_image'));
      request.fields.addAll({...body});
      request.headers.addAll({...headers ?? {}});
      request.files
          .add(await http.MultipartFile.fromPath('profile_picture', filePath));
      var response = await request.send().timeout(
            Duration(
              seconds: 7,
            ),
          );
      final responseData = await http.Response.fromStream(response);
      responseJson = _returnResponse(responseData);
    } on SocketException {
      debugPrint('No net');
      throw FetchDataException(
        message: 'No Internet connection',
      );
    } on TimeoutException {
      if (Loader.isShown) {
        Loader.hide();
      }
    }
    debugPrint(
      'api post.',
    );
    return responseJson;
  }

  Future<dynamic> put(
    String url,
    dynamic body,
  ) async {
    debugPrint('Api Put, url $url');
    dynamic responseJson;
    try {
      final response = await http.put(
        Uri.parse(
          _baseUrl + url,
        ),
        body: body,
      );
      responseJson = _returnResponse(
        response,
      );
    } on SocketException {
      debugPrint(
        'No net',
      );
      throw FetchDataException(
        message: 'No Internet connection',
      );
    }
    debugPrint('api put.');
    debugPrint(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(
    String url,
  ) async {
    debugPrint(
      'Api delete, url $url',
    );
    dynamic apiResponse;
    try {
      final response = await http.delete(
        Uri.parse(
          _baseUrl + url,
        ),
      );
      apiResponse = _returnResponse(
        response,
      );
    } on SocketException {
      debugPrint('No net');
      throw FetchDataException(
        message: 'No Internet connection',
      );
    }
    debugPrint(
      'api delete.',
    );
    return apiResponse;
  }
}

dynamic _returnResponse(
  http.Response response,
) {
  switch (response.statusCode) {
    case 200:
      var responseJson;
      try {
        responseJson = json.decode(
          response.body.toString(),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        Loader.hide();
      }
      return responseJson;
    case 400:
      var responseJson = json.decode(
        response.body.toString(),
      );
      return responseJson;
    case 401:
    case 403:
      throw UnauthorisedException(
        response.body.toString(),
      );
    case 500:
    case 201:
      var responseJson = json.decode(
        response.body.toString(),
      );
      return responseJson;
    default:
      throw FetchDataException(
        message:
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
      );
  }
}
