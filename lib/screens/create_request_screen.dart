import 'package:diplom2/design_consts.dart';
import 'package:diplom2/firebase_provider.dart';
import 'package:diplom2/widgets/dialog.dart';
import 'package:diplom2/widgets/text_form.dart';
import 'package:flutter/material.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({Key? key}) : super(key: key);

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DesignConsts.mainColor,
        title: const Text('Создание заявки'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextForm(
                      controller: nameController,
                      label: 'Название',
                    ),
                    CustomTextForm(
                      controller: locationController,
                      label: 'Место проведения',
                    ),
                    CustomTextForm(
                      controller: dateController,
                      label: 'Дата',
                      textInputType: TextInputType.number,
                    ),
                    CustomTextForm(
                      controller: infoController,
                      label: 'Описание',
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    String docId = await addRequest(
                      name: nameController.text,
                      date: dateController.text,
                      info: infoController.text,
                      location: locationController.text,
                      authorPhone: userModel!.phone,
                      authorSurname: userModel!.surname,
                      authorName: userModel!.name,
                      authorUid: userModel!.uid,
                    );
                    refactorUserData(
                      surname: userModel!.surname,
                      name: userModel!.name,
                      patronymic: userModel!.patronymic,
                      date: userModel!.date,
                      phone: userModel!.phone,
                      requestsIdList: [...userModel!.requestsIdList, docId],
                      uid: userModel!.uid,
                    );
                    await showDialog(
                      context: context,
                      builder: (_) {
                        return const CustomDialog(text: 'Заявка успешно создана');
                      },
                    );
                    await getUserData(userModel!.uid);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Создать заявку',
                ),
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
