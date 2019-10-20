import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icollection/AppBar.dart';
import 'package:icollection/Firestore/Leitura.dart';
import 'package:icollection/Login/auth.dart';
//Arquivo onde esta todos os items do menu Lateral
import 'Login/Tela_Auth.dart';
import 'MenuLateral.dart';
import 'Produto/ListarProdutos.dart';
import 'Produto/ListarProdutosTeste.dart';

enum WidgetMarker { login, menu }

Autentica auth = Autentica();

class Principal extends StatefulWidget {
  @override
  _Principal createState() => new _Principal();
}

Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
  List<String> values = snapshot.data;
  return new ListView.builder(
    itemCount: values.length,
    itemBuilder: (BuildContext context, int index) {
      return new Column(
        children: <Widget>[
          new ListTile(
            title: new Text(values[index]),
          ),
          new Divider(
            height: 2.0,
          ),
        ],
      );
    },
  );
}

class _Principal extends State<Principal> {
  //Por padrao escolhe a tela de login
  WidgetMarker selectedWidgetMarker = WidgetMarker.login;

  String _email;
  String _imagemURL;
  String _nomeUsuario;
  String _telefone;
  List items;

  @override
  initState() {
    super.initState();
    doAsyncStuff();
  }

  doAsyncStuff() async {
    var auth = await FirebaseAuth.instance.currentUser();
    try {
      setState(() {
        selectedWidgetMarker = WidgetMarker.menu;
        print(auth.toString());
        this._email = auth.email.toString();
        this._imagemURL = auth.photoUrl.toString();
        this._nomeUsuario = auth.displayName.toString();
        this._telefone = auth.phoneNumber.toString();
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

      //teclado nao sobrepor o campo
        //resizeToAvoidBottomPadding: true,

        //Lista todos os produtos nao importa se esta ou nao utenticado
        body: ListViewNote(), //ListagemGeralProdutos(),
        appBar: BaseAppBar(
          appBar: AppBar(),
          widgets: <Widget>[
            //Items que serão exibidos na AppBar
            IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                
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
        //Passa os dados do usuario autenticado para o menu lateral
        return MenuLateral(_email, _imagemURL, _nomeUsuario, _telefone);
    }

    return MenuLateral(_email, _imagemURL, _nomeUsuario, _telefone);
  }
}

Future<String> getCurrentUser() async {
  String _u = auth.googleUser().toString();

  print(_u);
  return auth.googleUser();
}
