import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clickbiuda/models/Product.dart';
import 'package:clickbiuda/tools/constants.dart';
import 'components/productCard.dart';

class MyProduct extends StatefulWidget {
  static const String id = '/myproductpage';

  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idLoggedUser;

  _recuperaDadosUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = auth.currentUser;
    _idLoggedUser = loggedUser.uid;
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {
    await _recuperaDadosUsuarioLogado();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("my_products")
        .doc(_idLoggedUser)
        .collection("products")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _removerAnuncio(String idProduct) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("my_products")
        .doc(_idLoggedUser)
        .collection("products")
        .doc(idProduct)
        .delete()
        .then((_) {
      db.collection("products").doc(idProduct).delete();
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando anúncios"),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.black,
        backgroundColor: kPrimaryColor,
        title: Text("Meus Anúncios"),
        actions: [
          IconButton(
              icon: Icon(Icons.local_offer_rounded),
              onPressed: () => Navigator.pushNamed(context, "/new-product"))
        ],
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:

              //Exibe mensagem de erro
              if (snapshot.hasError) return Text("Erro ao carregar os dados!");

              QuerySnapshot querySnapshot = snapshot.data;

              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, indice) {
                    List<DocumentSnapshot> products =
                        querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = products[indice];
                    Product product =
                        Product.fromDocumentSnapshot(documentSnapshot);

                    return ProductCard(
                      product: product,
                      onTapItem: () {
                        Navigator.pushNamed(context, "/productdetails",
                            arguments: product);
                      },
                      onPressedRemover: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content:
                                    Text("Deseja realmente excluir o anúncio?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Remover",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      _removerAnuncio(product.id);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    );
                  });
          }

          return Container();
        },
      ),
    );
  }
}
