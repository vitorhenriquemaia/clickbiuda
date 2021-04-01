import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

class CustomizedInput extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;
  final int maxLines;
  final TextAlign textAlign;
  final List<TextInputFormatter> inputFormatters;
  final Function(String) validator;
  final Function(String) onSaved;
  final Function(String) onChanged;


  CustomizedInput({
    @required this.controller,
    @required this.hint,
    this.obscure = false,
    this.autofocus = false,
    this.type = TextInputType.text,
    this.inputFormatters,
    this.maxLines,
    this.textAlign,
    this.validator,
    this.onSaved,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      obscureText: this.obscure,
      autofocus: this.autofocus,
      keyboardType: this.type,
      onSaved: this.onSaved,
      inputFormatters: this.inputFormatters,
      validator: this.validator,
      maxLines: this.maxLines,
      textAlign: this.textAlign,
      style: TextStyle(fontSize: 20),      
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        hintText: this.hint,
        border: OutlineInputBorder(   
          borderSide: BorderSide(color: kPrimaryColor),       
            borderRadius: BorderRadius.circular(32.0)
        ),
      ),
    );
  }
}
