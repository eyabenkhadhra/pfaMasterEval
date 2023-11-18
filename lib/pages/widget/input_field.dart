import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  String hintText;
  double height;
  double width;
  int? lines;
  Widget? suffix;
  TextEditingController controller;
  InputField(
      {Key? key,
      required this.hintText,
      this.lines,
      required this.height,
      required this.width,
      required this.controller,
      this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: TextFormField(
        maxLines: lines != null ? lines : null,
        validator: (value) {
          if (value!.isEmpty) {
            return "champ obligatoire";
          }
        },
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: suffix != null ? suffix : null,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          label: Text(hintText),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              width: 2.0,
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
