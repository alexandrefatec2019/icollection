import 'package:flutter/material.dart';

import 'Login/auth.dart';

class MenuLateral extends StatelessWidget {
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
        _criarItemMenu(icon: Icons.exit_to_app, text: 'Sair', onTap: signOutGoogle),
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
          backgroundImage: AssetImage('images/smeagol.jpg'),
          radius: 100,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black45,
          ),
          child: Text(
            'Smeagol B',
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
