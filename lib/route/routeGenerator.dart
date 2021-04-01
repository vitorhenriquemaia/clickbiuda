import 'package:clickbiuda/auth/reset.dart';
import 'package:clickbiuda/auth/signIn.dart';
import 'package:clickbiuda/auth/signup.dart';
import 'package:clickbiuda/products/createProduct.dart';
import 'package:clickbiuda/products/myProduct.dart';
import 'package:clickbiuda/products/productDetails.dart';
import 'package:clickbiuda/products/productSearch.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch( settings.name ){


      case "/":
        return MaterialPageRoute(
          builder: (_) => ProductHomePage()
        );
        
      case "/signin":
        return MaterialPageRoute(
          builder: (_) => SignIn()
        );

      case "/signup":
        return MaterialPageRoute(
          builder: (_) => SignUp()
        );    

      case "/resetscreen":
        return MaterialPageRoute(
          builder: (_) => ResetScreen()
        );
        
      // case "/profile":
      //   return MaterialPageRoute(
      //     builder: (_) => ProfilePage()
      //   );

      case "/productmine":
        return MaterialPageRoute(
            builder: (_) => MyProduct()
        );

      case "/new-product":
        return MaterialPageRoute(
            builder: (_) => CreateProduct()
        ); 

      case "/productdetails":
        return MaterialPageRoute(
            builder: (_) => ProductDetails(args)
        );
        
      default:
        _routeError();

    }
  }

  static Route<dynamic> _routeError(){

    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text("Tela não  encontrada!"),
          ),
          body: Center(
            child: Text("Tela não encontrada!"),
          ),
        );
      }
    );

  }
}