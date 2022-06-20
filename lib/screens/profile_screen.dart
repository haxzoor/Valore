import 'package:diplom2/design_consts.dart';
import 'package:diplom2/firebase_provider.dart';
import 'package:diplom2/screens/auth_screen.dart';
import 'package:diplom2/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: DesignConsts.mainColor,
              width: MediaQuery.of(context).size.width,
              height: 220,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userModel!.surname + " " + userModel!.name,
                      style: DesignConsts.whiteHeaderTextStyle,
                    ),
                    const SizedBox(height: 30),
                    Text('Дата рождения: ' + userModel!.date, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 10),
                    Text('Почта: ' + userFire!.user!.email!, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 10),
                    Text('Телефон: ' + userModel!.phone, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingScreen()));
                      setState(() {});
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.settings),
                        SizedBox(width: 10),
                        Text('Настройки'),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(DesignConsts.mainColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await SharedPreferences.getInstance().then((value) async {
                        value.remove('email');
                        value.remove('pass');
                      });
                      await exit();
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const AuthScreen()));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text('Выход'),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(DesignConsts.mainColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
