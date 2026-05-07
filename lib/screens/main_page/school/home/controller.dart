import 'dart:async';

import 'package:pasti/models/meal.dart';
import 'package:pasti/models/school.dart';
import '../../../../helper_functions/api.dart';
import '../../../../helper_functions/loading.dart';
import '../../../../helper_functions/navigation.dart';
import '../../../../models/student.dart';
import '../../../../shared/dialogs.dart';


int meals = 0;
int newMeals = 0;
int students = 0;
int newStudents = 0;
Future countsFunction(context,
    {bool load = true})async{

  if(load){
    loading(context);
  }
  try{
    Map apiData = await handleApi(context, route: 'school/home',isPost: false,
    header: {
      "Authorization":school.token
    });
    if(load){
      navPop(context);
    }
    if(apiData['status']==1){
      Map data = apiData['data']['data'];
      meals = data['meal_count'];
      students = data['user_count'];
      newMeals = data['new_menus_count'];
      newStudents = data['new_students_count'];

    }else if(apiData['status']==2){

      showSnackBar(context, apiData['message']);
    }
  }catch(e){

  }
}

List<Meal> mealsList = [];

Future getMealFunction(context,{bool filter = false,String? from,String? to,
bool load = true})async{

  if(load)loading(context);
  List<Meal> list = [];
  String url = 'school/today_meals';
  if(filter){
    url += '?from_date=$from&to_date=$to';
  }
  try{
    Map apiData = await handleApi(context, route: url,
        header: {
          "Authorization":school.token
        },isPost: false);
    if(load)navPop(context);
    if(apiData['status']==1){
      for(var l in apiData['data']['data']['meals']){
        list.add(Meal.fromJson(l,getUsers: true));
      }

    }else if(apiData['status']==2){

      showSnackBar(context, apiData['message']);
    }
  }catch(e){

  }
  mealsList = list;
}

Future<List<Meal>> getNewMealFunction(context,)async{

  loading(context);
  List<Meal> list = [];
  String url = 'school/new_menus';

  try{
    Map apiData = await handleApi(context, route: url,
        header: {
          "Authorization":school.token
        },isPost: false);
    navPop(context);
    if(apiData['status']==1){
      for(var l in apiData['data']['data']){
        list.add(Meal.fromJson(l['menu']));
      }

    }else if(apiData['status']==2){

      showSnackBar(context, apiData['message']);
    }
  }catch(e){

  }
  return list;
}




List<Student> studentList = [];

Future getStudentFunction(context,{bool search = false,String? name})async{

  loading(context);
  List<Student> list = [];
  String url = 'school/students';
  if(search){
    url += '?name=$name';
  }
  try{
    Map apiData = await handleApi(context, route: url,
        header: {
          "Authorization":school.token
        },isPost: false);
    navPop(context);
    if(apiData['status']==1){
      for(var s in apiData['data']['data']['users']){
        list.add(Student.fromJson(s));
      }

    }else if(apiData['status']==2){

      showSnackBar(context, apiData['message']);
    }
  }catch(e){

  }
  studentList = list;
}

Future<List<MealStudent>> getSchoolMenuFunction(context,
    )async{
  List<MealStudent> list = [];
  loading(context);
  try{
    Map apiData = await handleApi(context, route: 'school/get_school_meals',isPost: false,
        header: {
          "Authorization":school.token
        });
    navPop(context);
    if(apiData['status']==1){
      for(var m in apiData['data']['data']['meals']){
        list.add(MealStudent.fromJson(m));
      }

    }else if(apiData['status']==2){

      showSnackBar(context, apiData['message']);
    }
  }catch(e){
  }
  return list;
}