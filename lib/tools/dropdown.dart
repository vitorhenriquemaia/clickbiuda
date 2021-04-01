import 'package:flutter/material.dart';

import 'constants.dart';

class Configuracoes {

  static List<DropdownMenuItem<String>> getStates(){

    List<DropdownMenuItem<String>> dropStatesListItens  = [];

    dropStatesListItens.add(
        DropdownMenuItem(child: Text(
            "Limpar", style: TextStyle(
              color: kPrimaryColor,
            ),
          ),
        )
    );

    dropStatesListItens.add(
        DropdownMenuItem(child: Text("Rio de Janeiro"), value: "RJ",)
    );

    return dropStatesListItens;
  }

  static List<DropdownMenuItem<String>> getCategories(){

    List<DropdownMenuItem<String>> dropCategoriesListItens = [];

    dropCategoriesListItens.add(
        DropdownMenuItem(child: Text("Limpar", style: TextStyle(
             color: kPrimaryColor
        ),
          ),
         )
    );

     dropCategoriesListItens.add(
        DropdownMenuItem(child: Text("Geral"), value: "geral",)
    );

     dropCategoriesListItens.add(
        DropdownMenuItem(child: Text("Sexshop"), value: "sexshop",)
    );

     dropCategoriesListItens.add(
        DropdownMenuItem(child: Text("lingerie"), value: "lingerie",)
    );

    return dropCategoriesListItens;

  }

  static List<DropdownMenuItem<String>> getPlaces(){

    List<DropdownMenuItem<String>> dropPlacesListItens = [];

    dropPlacesListItens.add(
        DropdownMenuItem(child: Text("Limpar", style: TextStyle(
             color: kPrimaryColor
        ),
          ),
         )
    );
    dropPlacesListItens.add(
        DropdownMenuItem(child: Text("Zona norte"), value: "zn",)
    );
    dropPlacesListItens.add(
        DropdownMenuItem(child: Text("Zona sul"), value: "zn",)
    );
    dropPlacesListItens.add(
        DropdownMenuItem(child: Text("Zona oeste"), value: "zo",)
    );
    dropPlacesListItens.add(
        DropdownMenuItem(child: Text("Centro"), value: "centro",)
    );
    dropPlacesListItens.add(
        DropdownMenuItem(child: Text("Baixada"), value: "bf",)
    );
    dropPlacesListItens.add(
        DropdownMenuItem(child: Text("Niterói"), value: "Niterói",)
    );
    dropPlacesListItens.add(
        DropdownMenuItem(child: Text("São gonçalo"), value: "camping",)
    );
    return dropPlacesListItens;
  }

  static List<DropdownMenuItem<String>> getSize(){

    List<DropdownMenuItem<String>> dropSizeListItens  = [];

    dropSizeListItens.add(
        DropdownMenuItem(child: Text(
            "Limpar", style: TextStyle(
              color: kPrimaryColor,
            ),
          ),
        )
    );

    dropSizeListItens.add(
        DropdownMenuItem(child: Text("Não se aplica"), value: "nulo",)
    );

    

    dropSizeListItens.add(
        DropdownMenuItem(child: Text("34"), value: "34",)
    );
    dropSizeListItens.add(
        DropdownMenuItem(child: Text("36"), value: "36",)
    );
    dropSizeListItens.add(
        DropdownMenuItem(child: Text("38"), value: "38",)
    );
    dropSizeListItens.add(
        DropdownMenuItem(child: Text("40"), value: "40",)
    );
    dropSizeListItens.add(
        DropdownMenuItem(child: Text("42"), value: "42",)
    );
    dropSizeListItens.add(
        DropdownMenuItem(child: Text("44"), value: "44",)
    );
    dropSizeListItens.add(
        DropdownMenuItem(child: Text("46"), value: "46",)
    );
    dropSizeListItens.add(
        DropdownMenuItem(child: Text("48"), value: "48",)
    );
    dropSizeListItens.add(
        DropdownMenuItem(child: Text("50"), value: "50",)
    );

    return dropSizeListItens;
  }

}