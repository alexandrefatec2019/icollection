import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icollection/AppBar.dart';
import 'package:icollection/Login/Google.dart';
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

      //Menu lateral, verifica antes se estiver autenticado,
      //se estiver abre o menu Padrao, se nao abre com botoes para autenticar
      drawer: _menuAuth(),
    );

    return scaffold;
  }
}

Widget _menuAuth() {
  
  //getCurrentUser();
  if (getCurrentUser() != null) {
    return MenuLateral();
  } else {
    return LoginPage();
  }
}

Future<String> getCurrentUser() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();

  print("mail " + user.email);
  return null;
}

