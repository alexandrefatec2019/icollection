import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icollection/AppBar.dart';
import 'package:icollection/Login/auth.dart';
import 'package:icollection/main.dart';
//Arquivo onde esta todos os items do menu Lateral
import 'Login/Tela_Auth.dart';
import 'MenuLateral.dart';
import 'Produto/ListarProdutosPrincipal.dart';


//Variaveis globais! (em teste)
import 'VariaveisGlobais/UsuarioGlobal.dart' as g;
import 'package:show_dialog/show_dialog.dart' as dialog;


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
    verificaAuth();
  }

  //Se estiver autenticado chama o menu, se nao chama a autenticação
  verificaAuth() async {
    var auth = await FirebaseAuth.instance.currentUser();

    if (auth?.isEmailVerified != null) {
      setState(() {
        selectedWidgetMarker = WidgetMarker.menu;
        print('xxxxxxxxxxxxxxxxxxxxxxxxxxxAAAAAAAAAAAAAAx\n\n\n\n' + auth.providerData[1].uid+'\n\n\n\n');
        this._email = auth?.email.toString();
        this._imagemURL = auth?.photoUrl.toString();
        this._nomeUsuario = auth?.displayName.toString();
        this._telefone = auth?.phoneNumber.toString();
      });
    } else {
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
        body: ListarProdutosPrincipal(), //ListagemGeralProdutos(),
        appBar: BaseAppBar(
          appBar: AppBar(),
          widgets: <Widget>[
            //Items que serão exibidos na AppBar
            IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                //testando variavel global!
                 dialog.aboutDialog(context, g.photourl, "content");

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
        //Nao precisa mais passar os dados para o menu pois pega das global
        return MenuLateral();
    }

    return MenuLateral();
  }
}

// Future<String> getCurrentUser() async {
//   String _u = auth.googleUser().toString();

//   print(_u);
//   return auth.googleUser();
// }
