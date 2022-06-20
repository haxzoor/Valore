import 'package:diplom2/models/requests_model.dart';
import 'package:flutter/material.dart';
import '../screens/detail_request_screen.dart';

class RequestWidget extends StatelessWidget {
  final RequestModel request;
  final Function() onNavPop;

  const RequestWidget({Key? key, required this.request, required this.onNavPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailRequestScreen(request: request))).then((value) {
          onNavPop();
        });
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.date,
                style: const TextStyle(color: Color(0xFF5669FF)),
              ),
              Text(
                request.authorName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(request.name),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Text(
                      request.location,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
