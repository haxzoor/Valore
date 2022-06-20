import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/requests_model.dart';
import 'models/user_model.dart';

CollectionReference comments = FirebaseFirestore.instance.collection('comments');
CollectionReference requests = FirebaseFirestore.instance.collection('requests');
CollectionReference users = FirebaseFirestore.instance.collection('users');
FirebaseAuth auth = FirebaseAuth.instance;
UserCredential? userFire;
UserModel? userModel;

Future<void> exit() async {
  try {
    await auth.signOut();
    userModel = null;
    userFire = null;
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}

Future<void> authFire({required String email, required String password}) async {
  try {
    userFire = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}

Future<void> registerFire({required String email, required String password}) async {
  try {
    userFire = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}

Future<void> addUser({
  required String surname,
  required String name,
  required String patronymic,
  required String date,
  required String phone,
  required String uid,
}) async {
  try {
    await users.add({
      "uid": uid,
      "surname": surname,
      "name": name,
      "patronymic": patronymic,
      "date": date,
      "phone": phone,
    });
    userModel = UserModel(
      surname: surname,
      name: name,
      patronymic: patronymic,
      date: date,
      phone: phone,
      uid: uid,
      requestsIdList: [],
    );
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}

Future<void> getUserData(String uid) async {
  try {
    await users.where("uid", isEqualTo: uid).get().then(
      (value) {
        for (var element in value.docs) {
          Map mapResponse = element.data() as Map;
          userModel = UserModel(
            surname: mapResponse["surname"],
            name: mapResponse["name"],
            patronymic: mapResponse["patronymic"],
            date: mapResponse["date"],
            phone: mapResponse["phone"],
            uid: mapResponse["uid"],
            requestsIdList: mapResponse["requestsIdList"] ?? [],
          );
        }
      },
    );
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}

Future<void> refactorUserData({
  required String surname,
  required String name,
  required String patronymic,
  required String date,
  required String phone,
  required List requestsIdList,
  required String uid,
}) async {
  try {
    await users.where("uid", isEqualTo: uid).get().then(
      (value) {
        for (var element in value.docs) {
          users.doc(element.id).set({
            "uid": uid,
            "surname": surname,
            "name": name,
            "patronymic": patronymic,
            "date": date,
            "phone": phone,
            "requestsIdList": requestsIdList,
          });
        }
      },
    );
  } catch (e) {
    log(e.toString());
    throw Exception();
  }
}

Future<List<RequestModel>> getAllRequests() async {
  try {
    List<RequestModel> list = [];
    await requests.get().then(
      (value) {
        for (var element in value.docs) {
          Map mapResponse = element.data() as Map;
          list.add(RequestModel(
            name: mapResponse["name"],
            date: mapResponse["date"],
            info: mapResponse["info"],
            location: mapResponse["location"],
            authorSurname: mapResponse["authorSurname"],
            authorName: mapResponse["authorName"],
            authorUid: mapResponse["authorUid"],
            authorPhone: mapResponse["authorPhone"],
            id: element.id,
          ));
        }
      },
    );
    return list;
  } catch (e) {
    log(e.toString());
    throw Exception();
  }
}

Future<void> deleteRequest (String id) async {
  await requests.doc(id).delete();
}

Future<String> addRequest({
  required String name,
  required String date,
  required String info,
  required String location,
  required String authorSurname,
  required String authorName,
  required String authorUid,
  required String authorPhone,
}) async {
  try {
    DocumentReference doc = await requests.add({
      "name": name,
      "date": date,
      "info": info,
      "location" : location,
      "authorSurname": authorSurname,
      "authorName": authorName,
      "authorUid": authorUid,
      "authorPhone": authorPhone,
    });
    return doc.id;
  } catch (e) {
    log(e.toString());
    throw Exception();
  }
}

Future<List<UserModel>> getMembers(String projectId) async {
  try {
    List<UserModel> membersList = [];
    await users.where("requestsIdList", arrayContains: projectId).get().then(
          (value) {
        for (var element in value.docs) {
          Map mapResponse = element.data() as Map;
          membersList.add(UserModel(
            surname: mapResponse["surname"],
            name: mapResponse["name"],
            patronymic: mapResponse["patronymic"],
            date: mapResponse["date"],
            phone: mapResponse["phone"],
            uid: mapResponse["uid"],
            requestsIdList: mapResponse["requestsIdList"],
          ));
        }
      },
    );
    return membersList;
  } catch (e) {
    log(e.toString());
    throw Exception();
  }
}

Future<List<UserModel>> getMembersByUid(String uid) async {
  try {
    List<UserModel> membersList = [];
    List<RequestModel> requestsList = [];
    await requests.where("authorUid", isEqualTo: uid).get().then(
          (value) {
        for (var element in value.docs) {
          Map mapResponse = element.data() as Map;
          requestsList.add(RequestModel(
            name: mapResponse["name"],
            date: mapResponse["date"],
            info: mapResponse["info"],
            location: mapResponse["location"],
            authorSurname: mapResponse["authorSurname"],
            authorName: mapResponse["authorName"],
            authorUid: mapResponse["authorUid"],
            authorPhone: mapResponse["authorPhone"],
            id: element.id,
          ));
        }
      },
    );
    for (var element in requestsList) {
      await users.where("requestsIdList", arrayContains: element.id).get().then(
            (value) {
          for (var element in value.docs) {
            Map mapResponse = element.data() as Map;
            membersList.add(UserModel(
              surname: mapResponse["surname"],
              name: mapResponse["name"],
              patronymic: mapResponse["patronymic"],
              date: mapResponse["date"],
              phone: mapResponse["phone"],
              uid: mapResponse["uid"],
              requestsIdList: mapResponse["requestsIdList"],
            ));
          }
        },
      );
    }
    return membersList;
  } catch (e) {
    log(e.toString());
    throw Exception();
  }
}
