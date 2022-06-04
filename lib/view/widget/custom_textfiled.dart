import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled({
    Key? key,
    required this.hint,
    required this.text,
    this.validator,
    this.onSaved,
    this.onChanged,
  }) : super(key: key);
  final String hint;
  final String text;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Gotham',
              fontWeight: FontWeight.bold),
        ),
        TextFormField(
          style: TextStyle(color: Get.theme.textSelectionColor),
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
          textInputAction: TextInputAction.done,
          textAlign: TextAlign.start,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            hintStyle: TextStyle(
              color: Theme.of(context).textSelectionColor,
            ),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            disabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
