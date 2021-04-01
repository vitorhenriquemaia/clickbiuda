import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:clickbiuda/ad_helper.dart';
import 'package:clickbiuda/models/Product.dart';
import 'package:clickbiuda/tools/constants.dart';

import 'components/productCard.dart';

class ProductHomePage extends StatefulWidget {
  @override
  _ProductHomePageState createState() => _ProductHomePageState();
}

class _ProductHomePageState extends State<ProductHomePage> {
  BannerAd _ad;
  bool isLoaded;

  TextEditingController _controller = TextEditingController();
  List<String> itensMenu = [];

  Stream _stream =
      FirebaseFirestore.instance.collection('products').snapshots();
  String _searchType = "title";

   _escolhaMenuItem(String itemEscolhido){

    switch( itemEscolhido ){

      case "Meus anúncios" :
        Navigator.pushNamed(context, "/productmine");
        break;
      case "Entrar / Cadastrar" :
        Navigator.pushReplacementNamed(context, "/signin");
        break;
        case "Criar Produto" :
        Navigator.pushNamed(context, "/new-product");
        break;
      case "Deslogar" :
        _deslogarUsuario();
        break;

    }

  }

    _deslogarUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, '/');

  }

    Future _verificarUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;

    if( usuarioLogado == null ){
      itensMenu = [
        "Entrar / Cadastrar"
      ];
    }else{
      itensMenu = [
        "Criar Produto","Meus anúncios", "Deslogar"
      ];
    }

  }

  void _searchByField() {
    if (_searchType.isEmpty) {
      _stream = FirebaseFirestore.instance.collection('products').snapshots();
    } else {
      String text = _controller.text;
      _stream = FirebaseFirestore.instance
          .collection('products')
          .where(_searchType, isGreaterThanOrEqualTo: text)
          .snapshots();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
    _ad = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdHelper.bannerAdUnitId, 
      listener: AdListener(
        onAdLoaded: (_) {
        setState(() {
          isLoaded = true;
        });
        },
        onAdFailedToLoad: (_, error){
          print('Ad Failed to load with error: $error');
        }
      ), 
      request: AdRequest()
      );
      _ad.load();
  }

  @override 
  void dispose(){
    _ad?.dispose();
    super.dispose();
  }

  Widget checkForAd() {
   if (isLoaded == true){
     return Container(
       child: AdWidget(
         ad: _ad,
       ),
       width: _ad.size.width.toDouble(),
       height: _ad.size.height.toDouble(),
       alignment: Alignment.center,
     );
   } else {
     return CircularProgressIndicator();
   }
  }

  @override
  Widget build(BuildContext context) {
    var loadingData = Center(
      child: Column(
        children: [Text("Carregando anúncio"), CircularProgressIndicator()],
      ),
    );
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('#Click Biuda'),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 1.0, right: 1.0),
        child: Column(
          children: [          
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Container(
                // margin: EdgeInsets.all(kDefaultPadding),
                padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding, vertical: kDefaultPadding / 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      icon: Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                      ),
                      hintText: 'Exemplo: Lingerie',
                      hintStyle: TextStyle(color: Colors.white)),
                  controller: _controller,
                  onEditingComplete: _searchByField,
                ),
              ),
            ),            
            Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(child: checkForAd()),
          ),
            SizedBox(height: kDefaultPadding / 2),
            Expanded(
              child: Column(
                children: [                  
                  StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return loadingData;
                            break;
                          case ConnectionState.active:
                          case ConnectionState.done:
                            QuerySnapshot querySnapshot = snapshot.data;
                            if (querySnapshot.docs.length == 0) {
                              return Container(
                                padding: EdgeInsets.all(25),
                                child: Center(
                                  child: Text(
                                    "Sem anúncios no momento!",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }
                            return Expanded(
                              child: ListView.builder(
                                itemCount: querySnapshot.docs.length,
                                itemBuilder: (_, indice) {
                                  List<DocumentSnapshot> products =
                                      querySnapshot.docs.toList();
                                  DocumentSnapshot documentSnapshot =
                                      products[indice];
                                  Product product =
                                      Product.fromDocumentSnapshot(
                                          documentSnapshot);
                                  return ProductCard(
                                    product: product,
                                    onTapItem: () {
                                      Navigator.pushNamed(
                                          context, "/productdetails",
                                          arguments: product);
                                    },
                                  );
                                },
                                
                                
                              ),
                              
                            );
                        }
                        
                        return Container();
                      }),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
