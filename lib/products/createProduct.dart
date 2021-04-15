import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clickbiuda/models/Product.dart';
import 'package:clickbiuda/tools/constants.dart';
import 'package:clickbiuda/tools/customizedInput.dart';
import 'package:clickbiuda/tools/customizedbutton.dart';
import 'package:clickbiuda/tools/dropdown.dart';
import 'package:validadores/Validador.dart';

class CreateProduct extends StatefulWidget {

  static const String id = '/createproductpage';

  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  TextEditingController _controllerName = TextEditingController();

  List<File> _imageList = [];
  List<DropdownMenuItem<String>> _dropStatesListItens = [];
  List<DropdownMenuItem<String>> _dropPlacesListItens = [];
  List<DropdownMenuItem<String>> _dropCategoriesListItens = [];
  List<DropdownMenuItem<String>> _dropSizeListItens = [];

  final _formKey = GlobalKey<FormState>();
  Product _product;
  String _idLoggedUser;

  BuildContext _dialogContext;

  String _selectedItemState;
  String _selectedItemPlaces;
  String _selectedItemCategories;
  String _selectedItemSize;


  final picker = ImagePicker();

  _selectImageFromGallery() async{

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(File(pickedFile.path) != null){
      setState(() {
        _imageList.add(File(pickedFile.path));
      });
    }

  }

  _openDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
      builder: (BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Salvando anúncio, aguarde!")
              ],
            ),
          );
      }
    );
  }

 _saveAdvertise() async{
    _openDialog( _dialogContext );
    await _uploadImages();

    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = auth.currentUser;
    String idLoggedUser = loggedUser.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("my_products")
    .doc( idLoggedUser )
    .collection("products")
    .doc( _product.id )
    .set( _product.toMap() ).then((_){

      db.collection("products")
       .doc( _product.id )
       .set( _product.toMap() ).then((_){
         
        Navigator.pop(_dialogContext);
        Navigator.pop(context);

      });

    });

  }
  Future _uploadImages() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();

    for( var image in _imageList){
      String nameImage = DateTime.now().millisecondsSinceEpoch.toString();
      Reference file = pastaRaiz
          .child("my_products")
          .child( _product.id )
          .child( nameImage );
      UploadTask uploadTask = file.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;

      String url = await taskSnapshot.ref.getDownloadURL();
      _product.photos.add(url);
    }
  }

  _getUserData() async{
    
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = await auth.currentUser;
    _idLoggedUser = loggedUser.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =  await db.collection("users")
    .doc(_idLoggedUser)
    .get();

    Map<String, dynamic> data = snapshot.data();
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    _loadItensDropdown();
    _product = Product.generateId();
  }
  
  _loadItensDropdown(){

   // _dropPlacesListItens = Configuracoes.getPlaces();
   // _dropStatesListItens = Configuracoes.getStates();
    _dropCategoriesListItens = Configuracoes.getCategories();
    //_dropSizeListItens = Configuracoes.getSize();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        backgroundColor: kPrimaryColor,
        title: Text("Criar produto",
          style: TextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                  initialValue: _imageList,
                  validator: ( images ){
                    if( images.length == 0 ){
                      return "Necessário selecionar uma imagem!";
                    }
                    return null;
                  },
                  builder: (state){
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                              itemCount: _imageList.length + 1,
                              itemBuilder: (context, indice) {
                                if (indice == _imageList.length) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: (){
                                        _selectImageFromGallery();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: kPrimaryColor,
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                            Icons.add_a_photo,
                                              size: 50,
                                              color: Colors.white,
                                        ),
                                            Text(
                                              "Adicionar",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (_imageList.length > 0){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: (){
                                        showDialog(
                                            context: context,
                                          builder: (context) => Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.file(_imageList[indice]),
                                                TextButton(
                                                    child: Text("Excluir"),
                                                  onPressed: (){
                                                      setState(() {
                                                        _imageList.removeAt(indice);
                                                        Navigator.of(context).pop();
                                                      });
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage( _imageList[indice]),
                                        child: Container(
                                          color: Color.fromRGBO(255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.delete, color: Colors.red,),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              }
                           ),
                        ),
                        if( state.hasError )
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Padding(
                //         padding: EdgeInsets.all(8),
                //         child: DropdownButtonFormField(
                //           value: _selectedItemState,
                //           hint: Text("Estados"),
                //             onSaved: (state){
                //               _product.state = state;
                //             },
                //             style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 20
                //             ),
                //             items: _dropStatesListItens,
                //             validator: (valor){
                //             return Validador()
                //                 .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                //                 .valido(valor);
                //             },
                //             onChanged: (valor){
                //             setState(() {
                //               _selectedItemState = valor;
                //             });
                //             },
                //         ),
                //       ),
                //     ),                    
                //   ],
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Padding(
                //         padding: EdgeInsets.all(8),
                //         child: DropdownButtonFormField(
                //           value: _selectedItemPlaces,
                //           hint: Text("Regiões"),
                //           onSaved: (places){
                //            _product.places = places;
                //           },
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 20
                //           ),
                //           items: _dropPlacesListItens,
                //           validator: (valor){
                //             return Validador()
                //                 .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                //                 .valido(valor);
                //           },
                //           onChanged: (valor){
                //             setState(() {
                //               _selectedItemPlaces = valor;
                //             });
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _selectedItemCategories,
                          hint: Text("Categoria"),
                          onSaved: (category){
                           _product.category = category;
                          },
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          ),
                          items: _dropCategoriesListItens,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor){
                            setState(() {
                              _selectedItemCategories = valor;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Padding(
                //         padding: EdgeInsets.all(8),
                //         child: DropdownButtonFormField(
                //           value: _selectedItemSize,
                //           hint: Text("Tamanho"),
                //           onSaved: (size){
                //            _product.size = size;
                //           },
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 20
                //           ),
                //           items: _dropSizeListItens,
                //           validator: (valor){
                //             return Validador()
                //                 .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                //                 .valido(valor);
                //           },
                //           onChanged: (valor){
                //             setState(() {
                //               _selectedItemSize = valor;
                //             });
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    child: CustomizedInput(
                      controller: null,
                      hint: "Título",
                      textAlign: TextAlign.start,
                      validator: (valor){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .valido(valor);
                      },
                      onSaved: (title){
                        _product.title = title;
                      },
                    ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: CustomizedInput(
                    controller: null,
                    hint: "Locais de retirada",
                    textAlign: TextAlign.start,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                    onSaved: (places){
                      _product.places = places;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: CustomizedInput(
                    controller: _controllerName,
                    hint: "Vendedor",
                    textAlign: TextAlign.start,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                    onSaved: (vendor){
                      _product.vendor = vendor;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: CustomizedInput(
                    controller: null,
                    hint: "Preço",
                    textAlign: TextAlign.start,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                    onSaved: (price){
                      _product.price = price;
                    },
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: CustomizedInput(
                    controller: null,
                    hint: "Telefone",
                    textAlign: TextAlign.start,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                    onSaved: (phone){
                      _product.phone = phone;
                    },
                    type: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: CustomizedInput(
                    controller: null,
                    hint: "WhatsApp",
                    textAlign: TextAlign.start,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                    onSaved: (whatsapp){
                      _product.whatsapp = whatsapp;
                    },
                    type: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: CustomizedInput(
                    controller: null,
                    hint: "Descrição",
                    textAlign: TextAlign.start,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                    onSaved: (description){
                      _product.description = description;
                    },
                    maxLines: null,
                  ),
                ),
                CustomizedButton(
                  text: "Cadastrar Anúncio",
                  onPressed: (){
                    if( _formKey.currentState.validate() ){
                      //salvar campos
                      _formKey.currentState.save();
                      //configurar dialog context
                      _dialogContext = context;
                      //salvar anúncio
                      _saveAdvertise();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}