import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Principal.dart';

import 'Login/Tela_Auth.dart';

void main() async {

final VerificaAuth _auth = VerificaAuth();
  final bool isLogged = await _auth.isLogged();
  final Icollection icollection = Icollection(
    initialRoute: isLogged ? '/' : '/Login',
  );

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
