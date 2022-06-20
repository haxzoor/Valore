import 'dart:async';
import 'dart:developer';
import 'package:diplom2/models/user_model.dart';
import 'package:diplom2/screens/create_request_screen.dart';
import 'package:diplom2/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import '../design_consts.dart';
import '../firebase_provider.dart';
import '../models/requests_model.dart';
import '../widgets/request_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<RequestModel>? _list;

  @override
  void initState() {
    getAllRequests().then((value) {
      _list = value;
      setState(() {});
    });
    getMembersByUid(userFire!.user!.uid).then((value) {
      notiList = value;
    });
    timer ??= Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        log('timerTick');
        List<UserModel> newList = await getMembersByUid(userModel!.uid);
        UserModel? newUser;
        newUser = null;
        int index = 0;
        if (newList.length < notiList.length) {
          notiList = newList;
        }
        if (newList.length > notiList.length) {
          for (var elementOld in notiList) {
            if (newList[index].uid != elementOld.uid) {
              newUser = newList[index];
              newSubs = index;
              break;
            }
            index++;
          }
          notiList = newList;
          if (newUser != null) {
            if (newUser.uid != userModel!.uid) {
              notiController.add(newUser);
            }
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateRequestScreen())).then((value) {
            getAllRequests().then((value) {
              _list = value;
              setState(() {});
            });
          });
        },
        icon: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: DesignConsts.mainColor,
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
              child: Center(
                child: Text(
                  'Активные заявки',
                  style: DesignConsts.blackHeaderTextStyle,
                ),
              ),
            ),
            if (_list == null)
              const Text('Ищем заяки ...')
            else
              Column(
                children: _list!.map((e) {
                  if (userModel!.requestsIdList.contains(e.id)) {
                    return RequestWidget(
                      request: e,
                      onNavPop: () {
                        getAllRequests().then((value) {
                          _list = value;
                          setState(() {});
                        });
                      },
                    );
                  } else {
                    return const SizedBox(height: 0, width: 0);
                  }
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
