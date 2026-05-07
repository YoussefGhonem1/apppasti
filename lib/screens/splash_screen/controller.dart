import 'package:pasti/helper_functions/api.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/helper_functions/shared_pref.dart';
import 'package:pasti/helper_functions/small_functions.dart';
import 'package:pasti/models/settings.dart';
import 'package:pasti/screens/auth/login/controller.dart';
import '../../constants/var.dart';
import '../auth/login/view.dart';

Future startSplash(context) async {
  getSettings(context);
  await getToken();
  // if(token=="null"){
  //   await getToken();
  // }
  bool login2 = prefs.getBool('login') ?? false;
  login = login2;
  // Provider.of<NetWorkProvider>(context,listen: false).net();
  if (login) {
    // int id = prefs.getInt('id')??0;
    // String? apiToken = prefs.getString('apiToken');
    String? userName = prefs.getString('userName');
    String? pass = prefs.getString('pass');
    // bool isSchool = prefs.getBool('isSchool')??false;
    loginFunction(context, userName: userName!, pass: pass!, fromLogin: false);
  } else {
    await delay(2000);
    navPRRU(context, Login());
  }
}

Future<int?> getData(context, {required int id}) async {
  try {
    Map apiData = await handleApi(context,
        route: 'get_data', data: {'id': id, 'token': token});
    if (apiData['status'] == 1) {
      // user.user = user.User.fromJson(apiData['data']['user']);
      // unReadLength = apiData['data']['unReadLength'];
      // CategoryProvider categoryProvider =  Provider.of<CategoryProvider>(context,listen: false);
      // await categoryProvider.addCategory(apiData['data']['category']);
      // await addBanar(apiData['data']['banars']);
      // await setPops(apiData['data']['pops']);
      // payment = checkBool(apiData['data']['payment']);
      // clearPref(apiData['data']['pops']);
      return 2;
    }
    if (apiData['status'] == 2) {
      navPop(context);
      await prefs.setBool('login', false);
      await prefs.setInt('id', 0);
      // navPRRU(context, const Login());
      return 1;
      // showSnackBar(context, translateString(apiData['data']['message_en'], apiData['data']['message_ar']));
    } else {
      // navPop(context);
    }
  } catch (e) {
    // errorDialog(context,msg: e.toString());
    // navPop(context);
  }
  return null;
}

Future getSettings(
  context,
) async {
  try {
    Map apiData = await handleApi(context, route: 'setting', isPost: false);
    if (apiData['status'] == 1) {
      settings = Settings.fromJson(apiData['data']['data']);
      await getTime(context);
    }
    if (apiData['status'] == 2) {
      delay(2000);
      getSettings(context);
    }
  } catch (e) {
    delay(2000);
    getSettings(context);
  }
}

Future getTime(
  context,
) async {
  try {
    Map apiData = await handleApi(context, route: 'time', isPost: false);
    if (apiData['status'] == 1) {
      timeClass = TimeClass.fromJson(apiData['data']['data']);
    }
    if (apiData['status'] == 2) {
      delay(2000);
      getSettings(context);
    }
  } catch (e) {
    delay(2000);
    getSettings(context);
  }
}

Future getToken() async {
  // String? _token = await FirebaseMessaging.instance.getToken();
  String? _token =
      "dummy_token_removed_firebase"; // Placeholder since firebase is removed
  prefs.setString('token', _token);
  token = _token;
}
