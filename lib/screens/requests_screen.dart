import 'package:diplom2/design_consts.dart';
import 'package:diplom2/firebase_provider.dart';
import 'package:diplom2/models/requests_model.dart';
import 'package:diplom2/widgets/request_widget.dart';
import 'package:diplom2/widgets/text_form.dart';
import 'package:flutter/material.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RequestModel>? _list;

  @override
  void initState() {
    getAllRequests().then((value) {
      _list = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
              child: Center(
                child: Text(
                  'Заявки',
                  style: DesignConsts.blackHeaderTextStyle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomTextForm(
                controller: _searchController,
                onChanged: (_) {
                  setState(() {});
                },
                label: 'Поиск',
              ),
            ),
            if (_list == null)
              const Text('Ищем заяки ...')
            else
              Column(
                children: _list!.map((e) {
                  if (e.name.contains(_searchController.text)) {
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
