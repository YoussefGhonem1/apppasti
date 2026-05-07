
class NewStudent{
  int id;
  String personalId;
  String name;
  String className;

  NewStudent({required this.id, required this.className,required this.personalId, required this.name});

  factory NewStudent.fromJson(Map data){
    return NewStudent(id: data['id'],
        personalId: data['personal_id']==null?'':data['personal_id'].toString(), name: data['name'],
    className: data['class']['name']??"");
  }
}