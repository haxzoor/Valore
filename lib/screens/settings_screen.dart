import 'package:diplom2/design_consts.dart';
import 'package:diplom2/firebase_provider.dart';
import 'package:diplom2/widgets/text_form.dart';
import 'package:flutter/material.dart';

import '../widgets/dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController patronymicController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    surnameController.text = userModel!.surname;
    nameController.text = userModel!.name;
    patronymicController.text = userModel!.patronymic;
    dateOfBirthController.text = userModel!.date;
    phoneController.text = userModel!.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DesignConsts.mainColor,
        title: const Text('Настройки'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
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
              ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await refactorUserData(
                    surname: surnameController.text,
                    name: nameController.text,
                    patronymic: patronymicController.text,
                    date: dateOfBirthController.text,
                    phone: phoneController.text,
                    uid: userFire!.user!.uid,
                    requestsIdList: userModel!.requestsIdList,
                  );
                  await getUserData(userFire!.user!.uid);
                  await showDialog(
                    context: context,
                    builder: (_) {
                      return const CustomDialog(text: 'Данные успешно изменены');
                    },
                  );
                },
                child: const Text('Изменить данные'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(DesignConsts.mainColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
