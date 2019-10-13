import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icollection/AppBar.dart';
import 'package:icollection/Login/auth.dart';
//Arquivo onde esta todos os items do menu Lateral
import 'Login/Tela_Auth.dart';
import 'MenuLateral.dart';

enum WidgetMarker { login, menu }

Autentica auth = Autentica();

class Principal extends StatefulWidget {
  @override
  _Principal createState() => new _Principal();
}

class _Principal extends State<Principal> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.login;

  String _currentUserName;

  @override
  initState() {
    super.initState();
    doAsyncStuff();
  }

  doAsyncStuff() async {
    var name = await FirebaseAuth.instance.currentUser();
    try {
      setState(() {
        selectedWidgetMarker = WidgetMarker.menu;
        this._currentUserName = name.email.toString();
      });
    } catch (e) {
      setState(() {
        selectedWidgetMarker = WidgetMarker.login;
      });
    }
  }

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
              onPressed: () {
                print(_currentUserName);
              },
            ),
          ],
        ),

        //Menu lateral, verifica antes se estiver autenticado,
        //se estiver abre o menu Padrao, se nao abre com botoes para autenticar
        drawer: getCustomContainer() // _autenticado ? LoginPage() : Principal()
        );

    return scaffold;
  }

  Widget getCustomContainer() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.login:
        return LoginPage();
      case WidgetMarker.menu:
        return MenuLateral();
    }

    return MenuLateral();
  }
}

Future<String> getCurrentUser() async {
  String _u = auth.googleUser().toString();

  print(_u);
  return auth.googleUser();
}
