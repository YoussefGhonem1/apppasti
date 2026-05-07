class Student{
  int id;
  String name;
  String lastName;
  String personalId;
  int schoolId;
  String className;
  String token;

  Student(
      {required this.id,
        required this.name,
        required this.schoolId,
        required this.className,
        required this.token,
      required this.lastName,
      required this.personalId});
  factory Student.fromJson(Map data){

    return Student(id: data['id'], name: data['name'],
        schoolId: int.parse(data['school_id'].toString()), className: data['class']==null?''
            :data['class']['name']??"",
        token: data['token']==null?"":data['token'],lastName: data['last_name']??"",
        personalId: data['personal_id']==null?'':data['personal_id'].toString());
  }
}

late Student student;