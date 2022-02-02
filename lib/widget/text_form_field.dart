import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  String? hintText;
  TextStyle? hintStyle;
  bool? obscureText = false;
  Function(dynamic)? onChanged;
  Function(dynamic)? onFieldSubmitted;
  String? Function(String?)? validator;
  FocusNode? focusNode;
  TextEditingController? controller;
  double? radius;
  var borderColor;

  TextInputType? keyboardType;
  TextFormFieldWidget(
      {Key? key,
      this.hintText,
      this.hintStyle,
      this.obscureText,
      this.onChanged,
      this.borderColor,
      this.controller,
      this.radius,
      this.focusNode,
     /// this.scrollPadding,
      this.keyboardType,
      this.onFieldSubmitted,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: obscureText!,
        decoration: InputDecoration(
          hintText: hintText,
           border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius!),
                      borderSide: BorderSide(color: borderColor)),
          hintStyle: hintStyle,
        ),
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        focusNode: focusNode,
        keyboardType: keyboardType,
        controller: controller
      );
  }
}
