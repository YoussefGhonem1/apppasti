class School {
  int? id;
  String? name;
  String? image;
  String? code;
  String? address;
  String? token;
  bool? block;
  bool? isActive;
  String? userName;

  School(
      {required this.id,
      required this.name,
      required this.image,
      required this.token,
      required this.code,
      required this.address,
      required this.block,
      required this.isActive,
      required this.userName});
  factory School.fromJson(Map data) {
    return School(
        id: int.parse(data['id'].toString()),
        name: data['name'],
        image: data['image'],
        code: data['code'],
        address: data['address'],
        block: data['block'] == "yes",
        isActive: data['is_active'] == "yes",
        token: data['token'] == null ? "" : data['token'],
        userName: data['user_name']);
  }
}

late School school;
