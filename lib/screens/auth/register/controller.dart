import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pasti/screens/auth/login/view.dart';

import '../../../constants/var.dart';
import '../../../helper_functions/api.dart';
import '../../../helper_functions/loading.dart';
import '../../../helper_functions/navigation.dart';
import '../../../models/classes.dart';
import '../../../shared/dialogs.dart';
import '../../splash_screen/controller.dart';

Future schoolRegisterFunction(context,
    {required List<TextEditingController> inputs, required File? img}) async {
  loading(
    context,
  );
  while (token == 'null') {
    await getToken();
  }
  Map<String, dynamic> data = {
    'user_name': inputs[1].text,
    'password': inputs[2].text,
    "fcm_token": token,
    "name": inputs.first.text,
    "address": inputs.last.text,
    "image": img == null
        ? null
        : await MultipartFile.fromFile(img.path,
            filename: 'school${inputs.first.text}')
  };
  if (img == null) {
    data.remove('image');
  }
  try {
    Map apiData = await handleApi(
      context,
      route: 'school/register',
      formData: FormData.fromMap(data),
    );
    navPop(context);

    if (apiData['status'] == 1) {
      successDialog(context,
          msg:
              'La registrazione è andata a buon fine e il tuo account sarà attivato dall`amministrazione',
          then: () {
        navPRRU(context, Login());
      });
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {
    navPop(context);
  }
}

Future studentRegisterFunction(context,
    {required List<TextEditingController> inputs, required int classId}) async {
  loading(
    context,
  );
  while (token == 'null') {
    await getToken();
  }
  try {
    Map apiData = await handleApi(
      context,
      route: 'user/register',
      formData: FormData.fromMap({
        "name": inputs[0].text,
        "last_name": inputs[1].text,
        "personal_id": inputs[2].text,
        "school_code": inputs[3].text,
        "class_id": classId,
        'user_name': inputs[5].text,
        'password': inputs[6].text,
        "fcm_token": token,
      }),
    );
    navPop(context);

    if (apiData['status'] == 1) {
      successDialog(context,
          msg:
              'La registrazione è stata completata con successo e il tuo account sarà attivato dalla Azienda',
          then: () {
        navPRRU(context, Login());
      });
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {
    navPop(context);
  }
}

Future<List<Classes>> getClassesRegister(context,
    {required String code}) async {
  loading(
    context,
  );
  List<Classes> list = [];
  try {
    Map apiData = await handleApi(context,
        route: 'user/get_school_classes?school_code=$code', isPost: false);
    navPop(context);
    if (apiData['status'] == 1) {
      for (var c in apiData['data']['data']) {
        list.add(Classes.fromJson(c));
      }
      if (list.isEmpty) {
        showSnackBar(context,
            'Non ci sono filiali dell`azienda, contatta l`azienda per registrarti');
      }
      return list;
    }
  } catch (e) {
    navPop(context);
  }
  return list;
}
