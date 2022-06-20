import 'dart:developer';

import 'package:diplom2/design_consts.dart';
import 'package:diplom2/models/user_model.dart';
import 'package:diplom2/screens/main_screen.dart';
import 'package:diplom2/screens/notification_screen.dart';
import 'package:diplom2/screens/profile_screen.dart';
import 'package:diplom2/screens/requests_screen.dart';
import 'package:diplom2/widgets/noti_widget.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  bool noti = false;
  UserModel? lastNoti;
  static final List<Widget> _widgetOptions = <Widget>[
    const MainScreen(),
    const RequestsScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    notiController.stream.listen((item) {
      log('newElement');
      setState(() {
        noti = true;
        lastNoti = item;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              noti
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: NotiWidget(lastNoti!, false , onTapClose: (){
                                setState(() {
                                  noti = false;
                                });
                              },),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Главная",
                backgroundColor: DesignConsts.mainColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.featured_play_list_outlined),
                label: "Заявки",
                backgroundColor: DesignConsts.mainColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: "Уведомления",
                backgroundColor: DesignConsts.mainColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Профиль",
                backgroundColor: DesignConsts.mainColor,
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
