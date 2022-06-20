import 'dart:developer';
import 'package:diplom2/design_consts.dart';
import 'package:diplom2/firebase_provider.dart';
import 'package:diplom2/models/requests_model.dart';
import 'package:diplom2/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailRequestScreen extends StatefulWidget {
  final RequestModel request;

  const DetailRequestScreen({Key? key, required this.request}) : super(key: key);

  @override
  State<DetailRequestScreen> createState() => _DetailRequestScreenState();
}

class _DetailRequestScreenState extends State<DetailRequestScreen> {
  List<UserModel>? members;
  bool thisUser = false;

  @override
  void initState() {
    getMembers(widget.request.id).then((value) {
      members = value;
      setState(() {});
    });
    thisUser = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DesignConsts.mainColor,
        title: const Text('О заявке'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    widget.request.name,
                    style: DesignConsts.blackHeaderTextStyle,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: DesignConsts.mainColor,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    widget.request.date,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: DesignConsts.mainColor,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      widget.request.location,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text(
                    'Создатель: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.request.authorName),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'Участники: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              members == null
                  ? const SizedBox()
                  : Wrap(
                      children: members!.map((e) {
                        if (e.uid == userModel!.uid) {
                          Future.delayed(const Duration(microseconds: 100)).then((value) {
                            setState(() {
                              thisUser = true;
                            });
                          });
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: DesignConsts.mainColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                e.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 15),
              const Text(
                'Описание заявки: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Text(widget.request.info),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (widget.request.authorUid == userFire!.user!.uid) {
                      await deleteRequest(widget.request.id);
                      Navigator.of(context).pop();
                    } else if (thisUser) {
                      var url = "tel:${widget.request.authorPhone}";
                      try {
                        launchUrlString(url);
                      } catch (e) {
                        log(e.toString());
                      }
                    } else {
                      await refactorUserData(
                        surname: userModel!.surname,
                        name: userModel!.name,
                        patronymic: userModel!.patronymic,
                        date: userModel!.date,
                        phone: userModel!.phone,
                        requestsIdList: [...userModel!.requestsIdList, widget.request.id],
                        uid: userModel!.uid,
                      );
                      await getUserData(userModel!.uid);
                      members = await getMembers(widget.request.id);
                      setState(() {
                        thisUser = true;
                      });
                    }
                  },
                  child: Text(
                    widget.request.authorUid == userFire!.user!.uid
                        ? 'Удалить'
                        : thisUser
                            ? 'Позвонить'
                            : 'Присоединиться',
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(widget.request.authorUid == userFire!.user!.uid
                        ? Colors.red
                        : thisUser
                            ? Colors.green
                            : DesignConsts.mainColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
