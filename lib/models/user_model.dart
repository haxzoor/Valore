class UserModel {
  String surname;
  String name;
  String patronymic;
  String date;
  String phone;
  String uid;
  List requestsIdList;

  UserModel({
    required this.surname,
    required this.name,
    required this.patronymic,
    required this.date,
    required this.phone,
    required this.uid,
    required this.requestsIdList,
  });
}