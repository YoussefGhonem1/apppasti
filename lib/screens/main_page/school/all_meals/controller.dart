


import 'package:pasti/models/meal.dart';

import '../../../../helper_functions/api.dart';
import '../../../../helper_functions/loading.dart';
import '../../../../helper_functions/navigation.dart';
import '../../../../models/school.dart';
import '../../../../shared/dialogs.dart';

Future<bool> mealUpdateFunction(context,Meal meal
    ,bool accept)async{

  loading(context,);
  try{
    Map apiData = await handleApi(context, route: 'school/accept_refuse_menu',data: {
      'menu_id':meal.id,
      'status':accept?'accept':'refuse',
    },
        header: {
          "Authorization":school.token
        });
    navPop(context);
    if(apiData['status']==1){
      successDialog(context, msg: 'Operazione riuscita');
      return true;
    }else if(apiData['status']==2){
      showSnackBar(context, apiData['message']);
    }
  }catch(e){
    navPop(context);
  }
  return false;
}