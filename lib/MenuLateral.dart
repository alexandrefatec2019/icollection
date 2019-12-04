import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Usuario/perfil.dart';
import 'package:icollection/categoria.dart';
import 'package:page_transition/page_transition.dart';
import 'Login/auth.dart';
import 'Principal.dart';
import 'Produto/vendas.dart';
import 'VariaveisGlobais/UsuarioGlobal.dart' as g;
//import 'package:badges/badges.dart';

//Classe autenticação
Autentica auth = Autentica();
String _email;
String _imagemURL;
String _nomeUsuario;
String _telefone;

//Carrega apenas Imagem e nome do usuario dentro do menu lateral
//Apenas essa parte vai ter alteração no estado
class MenuLateral extends StatefulWidget {
  @override
  _Header createState() => new _Header();
}

class _Header extends State<MenuLateral> {
  DocumentSnapshot snapshot;

  @override
  initState() {
    super.initState();
    _atualizaDados();
  }

  _atualizaDados() {
    setState(() {
      _email = g.email;
      _imagemURL = g.photourl;
      _nomeUsuario = g.nome;
      _telefone = g.telefone;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => 
          Container(
          decoration: BoxDecoration(
            color: Color(0xff1c2634),
          ),
        );
    return Drawer(
        child: Stack(children: <Widget>[
      _buildDrawerBack(),
      ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _criarCabecalhoMenu(),
          Divider(
            color: Colors.white12,
          ),
          _criarItemMenu(
              icon: Icons.home,
              text: 'Página inicial',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Principal(),
                    ));
              }),
          _criarItemMenu(
              icon: Icons.account_box,
              text: 'Minha Conta',
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.leftToRight, child: Perfil(_email, _imagemURL, _nomeUsuario, _telefone))
                );
              }),

          _criarItemMenu(
              icon: Icons.shopping_cart,
              text: 'Anúncios',
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.leftToRight, child: Vendas())
                );
              }),
          Divider(
            color: Colors.white24,
            indent: 17,
            endIndent: 17,
          ),
          _criarItemMenu(
              icon: Icons.collections_bookmark,
              text: 'Categorias',
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.leftToRight, child: Categoria(snapshot))
                );
              }),

          Divider(
            color: Colors.white24,
            indent: 17,
            endIndent: 17,
          ),
          //ao clicar em sair chama a funçao logout do google e sai do app
          _criarItemMenu(
              icon: Icons.exit_to_app, text: 'Sair', onTap: auth.googleLogout),
        ],
      )
    ]));
  }
}
//Fim
Widget _buildStack() => Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        Stack(alignment: Alignment.topCenter, children: [
          Container(
            alignment: Alignment.center,
            height: 120.0,
            width: 120.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: CachedNetworkImageProvider(g.photourl),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Text(
              _nomeUsuario,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ])
      ],
    );

Widget _criarCabecalhoMenu() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(g.photourl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop)
        ),
        ),
      child: Stack(children: <Widget>[
        Center(child: _buildStack()
            ),
      ]));
}

Widget _criarItemMenu({IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.only(left: 17.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}

//Apenas para teste

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.contain, image: AssetImage('images/smeagol.jpg'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Flutter Step-by-Step",
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }
}
