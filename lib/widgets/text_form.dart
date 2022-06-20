import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final TextEditingController controller;
  final String label;
  final bool? pass;

  const CustomTextForm({
    Key? key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.textInputType,
    this.pass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        obscureText: pass ?? false,
        keyboardType: textInputType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Поле не может быть пустым';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
