import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Login/auth.dart';

//Classe autenticação
Autentica auth = Autentica();
String _email;
String _imagemURL;
String _nomeUsuario;
String _telefone;

//Carrega apenas Imagem e nome do usuario dentro do menu lateral
//Apenas essa parte vai ter alteração no estado
class MenuLateral extends StatefulWidget {
  final _email;
  final _imagemURL;
  final _nomeUsuario;
  final _telefone;

  MenuLateral(this._email, this._imagemURL, this._nomeUsuario, this._telefone);

  @override
  _Header createState() => new _Header();
}

class _Header extends State<MenuLateral> {
  @override
  initState() {
    super.initState();
    _atualizaDados();
    //print('==== '+widget.currentUser);
  }

  _atualizaDados() {
    setState(() {
      _email = widget._email;
      _imagemURL = widget._imagemURL;
      _nomeUsuario = widget._nomeUsuario;
      _telefone = widget._telefone;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
            color: Color(0xff1c2634),
      ),
    );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
        ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _criarCabecalhoMenu(),
        _criarItemMenu(
          icon: Icons.home,
          text: 'Página inicial',
        ),
        _criarItemMenu(
          icon: Icons.visibility,
          text: 'Visitados',
        ),
        _criarItemMenu(
          icon: Icons.shopping_cart,
          text: 'Vendas',
        ),
        Divider(),
        _criarItemMenu(icon: Icons.collections_bookmark, text: 'Categorias'),
        _criarItemMenu(icon: Icons.face, text: 'Procurar'),
        _criarItemMenu(icon: Icons.account_box, text: 'Minha Conta'),

        Divider(),
        _criarItemMenu(icon: Icons.bug_report, text: 'Report an issue'),
        Divider(),
        //ao clicar em sair chama a funçao logout do google e sai do app
        _criarItemMenu(
            icon: Icons.exit_to_app, text: 'Sair', onTap: auth.googleLogout),
        // ListTile(
        //   title: Text('0.0.1'),
        //   onTap: () {},
        // ),
      ],
    )]));
  }
}

//Fim

class ItemsMenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _criarCabecalhoMenu(),
        _criarItemMenu(
          icon: Icons.home,
          text: 'Página inicial',
        ),
        _criarItemMenu(
          icon: Icons.visibility,
          text: 'Visitados',
        ),
        _criarItemMenu(
          icon: Icons.shopping_cart,
          text: 'Vendas',
        ),
        Divider(),
        _criarItemMenu(icon: Icons.collections_bookmark, text: 'Categorias'),
        _criarItemMenu(icon: Icons.face, text: 'Procurar'),
        _criarItemMenu(icon: Icons.account_box, text: 'Minha Conta'),

        Divider(),
        _criarItemMenu(icon: Icons.bug_report, text: 'Report an issue'),
        Divider(),
        //ao clicar em sair chama a funçao logout do google e sai do app
        _criarItemMenu(
            icon: Icons.exit_to_app, text: 'Sair', onTap: auth.googleLogout),
        // ListTile(
        //   title: Text('0.0.1'),
        //   onTap: () {},
        // ),
      ],
    ));
  }
}

//teste de Imagem do usuario
Widget _buildStack() => Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(_imagemURL),
          radius: 100,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black45,
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
      ],
    );

Widget _criarCabecalhoMenu() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(color: Colors.black87),
      child: Stack(children: <Widget>[
        Center(child: _buildStack()
            // Text("Flutter Step-by-Step",
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 20.0,
            //         fontWeight: FontWeight.w500))
            ),
      ]));
}

//TODO falta criar referencias para quando clicar ir para outro lugar

Widget _criarItemMenu({IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
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
