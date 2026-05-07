import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pasti/constants/var.dart';

Future<Map<String, dynamic>> handleApi(context,
    {required String route,
    bool isPost = true,
    Map? data,
    FormData? formData,
    Map<String, dynamic>? header,
    bool isFromLogin = false}) async {
  final String url = domain + '/api/' + route;
  try {
    Response response = isPost
        ? await Dio().post(
            url,
            data: data ?? formData,
            options: Options(
              headers: header,
            ),
          )
        : await Dio().get(
            url,
            options: Options(
              headers: header,
            ),
          );
    if (response.data['code'] == 200 ||
        (isFromLogin != true && response.statusCode == 200)) {
      return {
        'status': 1,
        'data': response.data,
      };
    } else {
      String msg = '';
      if (response.data['message'] is String) {
        msg = response.data['message'];
      } else if (response.data['message'] is Map) {
        Map dataApi = response.data['message'];
        dataApi.forEach((key, value) {
          if (value is List) {
            for (var l in value) {
              msg += l + '\n';
            }
          }
          if (value is String) {
            msg += value + "\n";
          }
        });
        if (msg.endsWith('\n')) {
          msg = msg.substring(0, msg.length - 1);
        }
      }
      return {
        'status': 2,
        'message': msg,
      };
    }
  } on DioException catch (e) {
    debugPrint(e.toString());
    if (e.response != null) {
      print(e.response);
      // return {
      //   'status': e.response?.data['status'],
      //   'message': e.response?.data['message']
      // };
    }
  }
  return {'status': 0};
}
