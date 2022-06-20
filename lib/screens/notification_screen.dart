import 'dart:async';
import 'package:diplom2/design_consts.dart';
import 'package:diplom2/firebase_provider.dart';
import 'package:diplom2/models/user_model.dart';
import 'package:diplom2/widgets/noti_widget.dart';
import 'package:flutter/material.dart';

var notiController = StreamController<UserModel>();
List<UserModel> notiList = [];
int? newSubs;
Timer? timer;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Timer? timerNotiList;

  @override
  void initState() {
    timerNotiList ??= Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timerNotiList?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Уведомления', style: DesignConsts.blackHeaderTextStyle),
            ),
            const SizedBox(height: 30),
            ...notiList.map((e) {
              if (e.uid != userFire!.user!.uid) {
                return NotiWidget(e, notiList.indexOf(e) == newSubs);
              } else {
                return const SizedBox(height: 0, width: 0);
              }
            }).toList()
          ],
        ),
      ),
    );
  }
}
