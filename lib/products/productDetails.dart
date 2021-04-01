import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:clickbiuda/models/Product.dart';
import 'package:clickbiuda/tools/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../ad_helper.dart';

class ProductDetails extends StatefulWidget {
  Product product;
  ProductDetails(this.product);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Product _product;
  BannerAd _ad;
  bool isLoaded;

  List<Widget> _getImageList() {
    List<String> listUrlImages = _product.photos;
    return listUrlImages.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          image:
              DecorationImage(image: NetworkImage(url), fit: BoxFit.fitWidth),
        ),
      );
    }).toList();
  }

  _launchCall(String phone) async {
    if (await canLaunch("tel:$phone")) {
      await launch("tel:$phone");
    } else {
      print("Não pode fazer ligação");
    }
  }

  _launchWhatsApp(String whatsapp) async {
    final link = WhatsAppUnilink(
      phoneNumber: ("whatsapp:$whatsapp"),
      text: "Olá, gostei do anúncio na Nomad's yard",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  Widget checkForAd() {
    if (isLoaded == true) {
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
  void initState() {
    super.initState();
    _product = widget.product;
    _ad = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: AdListener(onAdLoaded: (_) {
          setState(() {
            isLoaded = true;
          });
        }, onAdFailedToLoad: (_, error) {
          print('Ad Failed to load with error: $error');
        }),
        request: AdRequest());
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Detalhe do anúncio",
          style: TextStyle(),
        ),
        //actions: [
        //   FavoriteButton(
        //       isFavorite: false,
        //       valueChanged: (_isFavorite) {
        //         if(_isFavorite == true){
        //           print('favoritado');
        //         }else{
        //           print('não favoritado');
        //         }
        //       },
        //     ),
        // ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 300,
                child: Carousel(
                  images: _getImageList(),
                  dotSize: 8,
                  dotBgColor: Colors.transparent,
                  dotColor: kPrimaryColor,
                  autoplay: false,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_product.title}",
                      style: TextStyle(fontSize: 25),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                      vertical: 5,
                    )),
                    Text(
                      "R\$ ${_product.price}",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        backgroundColor: kPrimaryColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:10.0),
                      child: Center(child: checkForAd()),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Descrição:",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_product.description}",
                      style: TextStyle(fontSize: 19),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        )),
                    Text(
                      "Local de retirada do produto:",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_product.places}",
                      style: TextStyle(fontSize: 19),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                      vertical: 5,
                    )),
                    Text(
                      "Vendedor:",
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${_product.vendor}",
                      style: TextStyle(fontSize: 19),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    Text(
                      "Contato:",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_product.phone}",
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: GestureDetector(
                        child: Container(
                          child: Text(
                            "WhatsApp",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.all(16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onTap: () {
                          _launchWhatsApp(_product.whatsapp);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
