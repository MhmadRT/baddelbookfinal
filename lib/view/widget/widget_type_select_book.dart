import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypeBookSelect extends StatelessWidget {
  const TypeBookSelect({Key? key, required this.text, required this.selected})
      : super(key: key);
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Chip(
        label: Text(
          text,
          style: TextStyle(
            color: Get.theme.textSelectionColor,
          ),
        ),
        backgroundColor: selected?Get.theme.cardColor:Theme.of(context).accentColor,
      ),
      margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
    );
  }
}
