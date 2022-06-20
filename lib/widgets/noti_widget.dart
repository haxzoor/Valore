import 'package:diplom2/models/user_model.dart';
import 'package:flutter/material.dart';

class NotiWidget extends StatelessWidget {
  final UserModel _userModel;
  final Function()? onTapClose;
  final bool newSub;

  const NotiWidget(this._userModel, this.newSub, {Key? key, this.onTapClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MediaQuery.of(context).size.width < 300
              ? const SizedBox()
              : SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/logovalore.png'),
                ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _userModel.surname + " " + _userModel.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Присоединился к вашей заявке',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 300 ? 9 : 14,
                ),
              ),
            ],
          ),
          onTapClose != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        onTapClose!();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ],
                )
              : newSub
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: 15,
                        width: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.red,
                        ),
                        child: const Center(
                          child: Text(
                            'new',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
        ],
      ),
    );
  }
}
