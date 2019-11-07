import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Principal.dart';
import 'package:icollection/Usuario/Cadastro.dart';
import 'package:icollection/model/usuarioModel.dart';

import 'Login/Tela_Auth.dart';
import 'package:icollection/Produto/produtoDATA.dart';

void main() async {
  print('Abriuuuuuuuuuuuu mainnnnnnnnnn');
  final VerificaAuth _auth = VerificaAuth();
  final bool isLogged = await _auth.isLogged();
  final Icollection icollection = Icollection(
    initialRoute: isLogged ? '/' : '/Login',
  );

FirebaseFirestoreService db = FirebaseFirestoreService();
db.criarProduto('mainInit', 'nomeProduto', 'descricao', 'material', 'valor', true, null);
  runApp(icollection);
}

class Icollection extends StatelessWidget {
  final String initialRoute;

  Icollection({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Rota padrao que o app vai inicializar (sem usar variavel)
      initialRoute: '/',
      routes: {
        //Tela principal onde vai listar os produtos anunciados
        '/': (context) => Principal(),
        //Tela de login ao clicar no botao menu
        '/Login': (context) => LoginPage(),
        '/CadastroUsuario': (context) =>
            CadDados(UsuarioModel(null, null, '', '', '', '')),
      },
    );
  }
}

class VerificaAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> isLogged() async {
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
