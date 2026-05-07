
// class MealDetails{
//   int id;
//   int menuId;
//   String name;
//   MealDetails({required this.id, required this.menuId, required this.name});
//
//   factory MealDetails.fromJson(Map data){
//     return MealDetails(id: data['id'], menuId: int.parse(data['menu_id'].toString()), name: data['name']);
//   }
// }


import 'package:pasti/helper_functions/small_functions.dart';
import 'package:pasti/models/cart.dart';
import 'package:pasti/models/school.dart';
import 'package:pasti/models/settings.dart';
import 'package:pasti/models/student.dart';
import 'package:pasti/screens/main_page/student/home/menu/check_out/controller.dart';

class Meal{
  int id;
  String name;
  String type;
  String description;
  int count;
  String? date;
  String price;
  List<Student> students;
  List<School> schools;
  Meal({required this.id, required this.name,
    required this.type, required this.count, required this.price,
    required this.description,this.date,required this.students,required this.schools});

  factory Meal.fromJson(Map data,{bool getUsers = false}){
    print(data);
    List<Student> student = [];
    List<School> schools = [];
    if(data.containsKey('users')&&getUsers){
      for(var s in data['users']){
        student.add(Student.fromJson(s));
      }
    }
    if(data.containsKey('schools')&&getUsers){
      for(var s in data['schools']){
        schools.add(School.fromJson(s));
      }
    }
    return Meal(id: data['id']
        , name: data['name'],
        type: data['type'],
        count: data['meal_count']==null?0:data['meal_count']
        ,description: data['description'],
    price: data['price']??"",date: data['date'],students: student,schools: schools);
  }
}



class MealStudent{
  int id;
  String date;
  String day;
  List<Meal> meals;
  MealStudent({required this.date, required this.day, required this.meals,required this.id});
  
  factory MealStudent.fromJson(Map data){
    List<Meal> meals = [];
    int id = 0;
    for(var m in data['meal_menus']){
      if(id==0&&m['is_selected']=='yes'){
        id = m['id'];
        Cart c = Cart(id: id, name: m['name'], date: reverseDate(data['date']), price: m['price']);
        if((((DateTime.now().day)+1)==int.parse(reverseDate(data['date']).split('-').first))&&
            (DateTime.now().hour>=int.parse(settings.orderTime.split(':').first))){

        }else{
          cart.add(c);
        }

      }
      meals.add(Meal.fromJson(m));
    }
    return MealStudent(date: reverseDate(data['date']), day: data['meal_day'], meals: meals, id: id);
  }
}