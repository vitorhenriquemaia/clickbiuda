import 'package:flutter/material.dart';

import 'constants.dart';



class CustomizedButton extends StatelessWidget {

  final String text;
  final Color colorText;
  final VoidCallback onPressed;

  CustomizedButton({
    @required
    this.text,
    this.colorText = Colors.white,
    this.onPressed
});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        this.text,
        style: TextStyle(
            color: this.colorText,
            fontSize: 20
        ),
      ),
      color: kPrimaryColor,
      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32)
      ),
      onPressed: this.onPressed
    );
  }
}
