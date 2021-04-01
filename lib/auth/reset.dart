import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clickbiuda/tools/constants.dart';
import 'package:clickbiuda/tools/customizedbutton.dart';
import 'package:shimmer/shimmer.dart';

class ResetScreen extends StatefulWidget {

  static const String id = '/resetpage';

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email;
    final auth = FirebaseAuth.instance;

    _resetPassword(){
      auth.sendPasswordResetEmail(email: _email);
      Navigator.of(context).pop();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset password"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SizedBox(
                    child: Shimmer.fromColors(
                      baseColor: kPrimaryColor,
                      highlightColor: Colors.white,
                      child: Text(
                        '#ClickBiuda',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:40,
                          fontWeight: FontWeight.bold
                        ),
                      ),                    
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:8),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    onChanged: (value){
                      setState(() {
                        _email = value;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: CustomizedButton(
                    text: "Recuperar senha",
                    onPressed: (){
                      _resetPassword();
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      // _errorMessage,
                      "",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}