import 'package:diplom2/design_consts.dart';
import 'package:diplom2/firebase_provider.dart';
import 'package:diplom2/screens/navigation_screen.dart';
import 'package:diplom2/widgets/dialog.dart';
import 'package:diplom2/widgets/text_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthScreenState { auth, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController patronymicController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  AuthScreenState state = AuthScreenState.auth;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences.getInstance().then((value) async {
        String? email = value.getString('email');
        String? pass = value.getString('pass');
        if (email != null && pass != null) {
          emailController.text = email;
          passController.text = pass;
          await authFire(
            password: passController.text,
            email: emailController.text,
          );
          await getUserData(userFire!.user!.uid);
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const NavigationScreen()));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(
                          child: Column(
                            children: [
                              state == AuthScreenState.auth
                                  ? SizedBox(
                                      height: MediaQuery.of(context).size.width / 3,
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: Image.asset('assets/logovalore.png'),
                                    )
                                  : const SizedBox(),
                              Text(
                                'V A L O R E',
                                style: TextStyle(
                                  color: DesignConsts.mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width < 300 ? 24 : 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            CustomTextForm(
                              controller: emailController,
                              label: 'Почта',
                            ),
                            CustomTextForm(
                              controller: passController,
                              label: 'Пароль',
                              pass: true,
                            ),
                            state == AuthScreenState.auth
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      CustomTextForm(
                                        controller: surnameController,
                                        label: 'Фамилия',
                                      ),
                                      CustomTextForm(
                                        controller: nameController,
                                        label: 'Имя',
                                      ),
                                      CustomTextForm(
                                        controller: patronymicController,
                                        label: 'Отчество',
                                      ),
                                      CustomTextForm(
                                        controller: dateOfBirthController,
                                        label: 'Дата рождения',
                                        textInputType: TextInputType.number,
                                      ),
                                      CustomTextForm(
                                        controller: phoneController,
                                        label: 'Телефон',
                                        textInputType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (state == AuthScreenState.auth) {
                                    String errorMessage = "Произошла ошибка";
                                    try {
                                      await authFire(
                                        password: passController.text,
                                        email: emailController.text,
                                      );
                                      await getUserData(userFire!.user!.uid);
                                      await SharedPreferences.getInstance().then((value) async {
                                        value.setString('email', emailController.text);
                                        value.setString('pass', passController.text);
                                      });
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          builder: (BuildContext context) => const NavigationScreen()));
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        errorMessage =
                                            'Для этого адреса электронной почты не найдено ни одного пользователя.';
                                      } else if (e.code == 'wrong-password') {
                                        errorMessage = 'Для этого пользователя указан неверный пароль.';
                                      } else {
                                        errorMessage = e.message.toString();
                                      }
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return CustomDialog(text: errorMessage);
                                        },
                                      );
                                    } catch (e) {
                                      errorMessage = e.toString();
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return CustomDialog(text: errorMessage);
                                        },
                                      );
                                    }
                                  } else if (state == AuthScreenState.register) {
                                    String errorMessage = "Произошла ошибка";
                                    try {
                                      await registerFire(
                                        password: passController.text,
                                        email: emailController.text,
                                      );
                                      await addUser(
                                        surname: surnameController.text,
                                        name: nameController.text,
                                        patronymic: patronymicController.text,
                                        date: dateOfBirthController.text,
                                        phone: phoneController.text,
                                        uid: userFire!.user!.uid,
                                      );
                                      await SharedPreferences.getInstance().then((value) async {
                                        value.setString('email', emailController.text);
                                        value.setString('pass', passController.text);
                                      });
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          builder: (BuildContext context) => const NavigationScreen()));
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        errorMessage = "Предоставленный пароль слишком слаб.";
                                      } else if (e.code == 'email-already-in-use') {
                                        errorMessage =
                                            "Учетная запись для этого адреса электронной почты уже существует.";
                                      } else {
                                        errorMessage = e.message.toString();
                                      }
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return CustomDialog(text: errorMessage);
                                        },
                                      );
                                    } catch (e) {
                                      errorMessage = e.toString();
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return CustomDialog(text: errorMessage);
                                        },
                                      );
                                    }
                                  }
                                }
                              },
                              child: Text(
                                state == AuthScreenState.auth ? 'Вход' : 'Регистрация',
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(DesignConsts.mainColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          state = AuthScreenState.auth;
                        });
                      },
                      child: Container(
                        color: state == AuthScreenState.auth ? Colors.white : DesignConsts.mainColor,
                        child: Center(
                          child: Text(
                            'Вход',
                            style: TextStyle(
                              color: state == AuthScreenState.auth ? DesignConsts.mainColor : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          state = AuthScreenState.register;
                        });
                      },
                      child: Container(
                        color: state == AuthScreenState.auth ? DesignConsts.mainColor : Colors.white,
                        child: Center(
                          child: Text(
                            'Регистрация',
                            style: TextStyle(
                              color: state == AuthScreenState.auth ? Colors.white : DesignConsts.mainColor,
                            ),
                          ),
                        ),
                      ),
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
