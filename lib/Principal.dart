import 'package:flutter/material.dart';
import 'package:icollection/AppBar.dart';
//Arquivo onde esta todos os items do menu Lateral
import 'MenuLateral.dart';

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold:
    var scaffold = Scaffold(
      body: null,
      appBar: BaseAppBar(
        appBar: AppBar(),
        widgets: <Widget>[
          //Items que serão exibidos na AppBar
          IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),

      //Menu Lateral !!!
      drawer: MenuLateral(),
    );

    return scaffold;
  }
}
