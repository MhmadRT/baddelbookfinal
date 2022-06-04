import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class FormFieldText extends StatefulWidget {
  final String? hints;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Widget? sIcon;
  final GestureTapCallback? onTap;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final int? maxLines;
  final String? label;

  const FormFieldText(
      {Key? key,
      this.hints,
      this.maxLines,
      this.label,
      this.onTap,
      this.initialValue,
      this.controller,
      this.onChanged,
      this.sIcon,
      this.validator})
      : super(key: key);

  @override
  _FormFieldState createState() => _FormFieldState();
}

class _FormFieldState extends State<FormFieldText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      onTap: widget.onTap,
      initialValue: widget.initialValue,
      enabled: widget.onTap == null ? true : false,
      validator: widget.validator,
      onChanged: widget.onChanged,
      style: TextStyle(color: Get.theme.textSelectionColor),
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hints,
        label: widget.label != null
            ? Text(
                widget.label ?? "",
                style: TextStyle(color: Get.theme.textSelectionColor),
              )
            : Text(widget.label ?? ""),
        suffixIcon: widget.sIcon,
        // labelText: widget.label,
        hintStyle: TextStyle(color: Color(0xff414852), fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.all(15),
      ),
    );
  }
}
