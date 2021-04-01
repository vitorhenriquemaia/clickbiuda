import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clickbiuda/models/user.dart';
import 'package:clickbiuda/tools/constants.dart';
import 'package:clickbiuda/tools/customizedInput.dart';
import 'package:clickbiuda/tools/customizedbutton.dart';
import 'package:shimmer/shimmer.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = "";

  _loginUser(Users users) {

    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
            email: users.email, password: users.password)
        .then((firebaseUser) {

         Navigator.pushReplacementNamed(context, '/');
      
    }).catchError((error) {
      setState(() {
        _errorMessage = "Erro ao autenticar usuário, verique e-mail e senha";
      });
    });
  }

  // _verifyUserIsOnline() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;

  //   User LoggedUser = await auth.currentUser;
  //   if (LoggedUser != null) {
  //     Navigator.pushReplacementNamed(context, "/");
  //   }
  // }

  _validateFields() {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty) {
        setState(() {
          _errorMessage = "";
        });

        Users users = Users();
        users.email = email;
        users.password = password;

        _loginUser(users);
      } else {
        setState(() {
          _errorMessage = "Preencha a senha";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Preencha o email utilizando @";
      });
    }
  }  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                CustomizedInput(
                  controller: _controllerEmail,
                  hint: "E-mail",
                  autofocus: true,
                  textAlign: TextAlign.center,
                  type: TextInputType.emailAddress,
                ),
                CustomizedInput(
                  controller: _controllerPassword,
                  hint: "Senha",
                  maxLines: 1,
                  obscure: true,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: CustomizedButton(
                    text: "Entrar",
                    onPressed: () {
                      _validateFields();
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Ainda não tem uma conta? Clique aqui!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        "Esqueceu sua senha?",
                        style: TextStyle(fontSize: 18, color: kPrimaryColor),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/resetscreen");
                      },
                    ),
                  ],
                ),                
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _errorMessage,
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
