import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clickbiuda/models/user.dart';
import 'package:clickbiuda/tools/constants.dart';
import 'package:shimmer/shimmer.dart';

class SignUp extends StatefulWidget {

   static const String id = '/signuppage';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  //controladores

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = "";
  String _textButton = "Nome da loja";
  bool _permission = false;

  _validateFields(){
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if(name.isNotEmpty && name.length >= 3){

        if(email.isNotEmpty && email.contains("@")){

          if(password.isNotEmpty){

            setState(() {
              _errorMessage = "";
            });

            Users users = Users();
            users.name = name;
            users.email = email;
            users.password = password;
            users.permission = users.verifyPermission(_permission);

            _registerUser( users );

          }else{
            setState(() {
              _errorMessage = "Preencha a senha";
            });
          }

        }else{
          setState(() {
            _errorMessage = "Preencha o email utilizando @";
          });
        }

    }else{
      setState(() {
        _errorMessage = "Preencha o nome maior que 3 caracteres";
      });
    }

  }

  _registerUser( Users users ) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: users.email,
        password: users.password
    ).then((firebaseUser){

      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("users")
      .doc( firebaseUser.user.uid )
      .set( users.toMap() );

     Navigator.pushReplacementNamed(context, "/");

    }).catchError((error){
      setState(() {
        _errorMessage = "Erro ao cadastrar usuário, verifique os campos e tente novamente!";
      });
    });
} 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Cadastrar"),
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
                    controller: _controllerName,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: 'Nome',
                      fillColor: Colors.white,                      
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:8),
                  child: TextField(
                    controller: _controllerEmail,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Senha",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)
                    ),
                  ),
                ),                
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    color: kPrimaryColor,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: (){
                      _validateFields();
                    },
                  ),
                ),
                Center(
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
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

