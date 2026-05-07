
import 'package:pasti/helper_functions/api.dart';
import 'package:pasti/helper_functions/loading.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/models/notification.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider extends ChangeNotifier{
  List<NotificationClass> notifications = [];
  int pageIndex = 1;
  bool finish = false;
  void clearList (){
    notifications.clear();
    pageIndex = 1;
    finish = false;
    notifyListeners();
  }
  Future addNotification(List _list)async{
    //print(_list);
    if(_list.isEmpty||_list==[]){
      finish = true;
      notifyListeners();
    }else{
      for (var element in _list) {
        Map el = element;
        notifications.add(NotificationClass.fromJson(el));
      }
      pageIndex++;
      notifyListeners();
    }
  }
  Future<String?> getNotifications(context)async{
    loading(context);
    Map apiData = await handleApi(context, route: 'get_notification/$pageIndex',
    data: {'type':1});
    if(apiData['status']==1){
      await addNotification(apiData['data']['notifications']);
      navPop(context);
      return 'Success';
    }else if(apiData['status']==2){
      navPop(context);
    }else{
      navPop(context);
    }
    return null;
  }
  void pagination(ScrollController controller,context){
    controller.addListener(() async{
      if(controller.position.atEdge&&controller.position.pixels>50){
        if(!finish){
          getNotifications(context);
        }
      }
    });
  }
}