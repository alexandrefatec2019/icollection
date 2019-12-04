import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Principal.dart';
import 'package:icollection/Usuario/Cadastro.dart';
import 'package:page_transition/page_transition.dart';
import 'Login/Tela_Auth.dart';
import 'Usuario/UsuarioDATA.dart';
import 'VariaveisGlobais/UsuarioGlobal.dart' as g;

void main()  {
  final firestore = Firestore.instance;
   Firestore.instance.settings(
     persistenceEnabled: true,
     cacheSizeBytes: 1048576
   );
  
  final VerificaAuth _auth = VerificaAuth();
  
  
  _auth.currentUser().then((_d) {
      
      if(_d != null){
        print('current user nao returnou vazio = '+_d);
    //Referencia no database ao usuario autenticado
    g.usuarioReferencia = firestore.collection('Usuario').document(_d);

    

    //Verifica se o usuario já tem cadastro no database
    //_d.email vem do autenticador
    _auth.readUsuarioDB(_d).then((_d) {
      if (_d) {
        //Retornar algo se o email existir no cadatro
        g.dadosUser = true;
        print('\n\n\n\n\n\n\n Usuario autenticado já cadastrado no database');
      } else {
        //Retornar algo se o cadastro ainda nao existir.6
        //forcar tela de cadastro talvez
        g.dadosUser = false;
        print('\n\n\n\n\n\n\nUsuario autenticado nao cadastrado no database');
      }
    });
  }});
  

  runApp(Icollection());
}

class Icollection extends StatelessWidget {
  final String initialRoute;

  Icollection({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Rota padrao que o app vai inicializar (sem usar variavel)
      //initialRoute: '/',
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        //Tela principal onde vai listar os produtos anunciados
        '/Principal': (BuildContext context) => Principal(),
        //Tela de login ao clicar no botao menu
        '/Login': (context) => LoginPage(),
        '/CadastroUsuario': (context) => CadDados(false),
      },
    );
  }
}

class VerificaAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestoreService db = new FirebaseFirestoreService();

//Faz a leitura do usuario já autenticado e cadastrado
//joga os dados nas var globais (recebe uma string Email)
  Future<bool> readUsuarioDB(String email) async {
    bool _ok = false;
    try {
      await db.lerUsuario(email).then((data) {
        g.id = data.id;
        g.nome = data.nome;
        g.cpfcnpj = data.cpfcnpj;
        g.email = data.email;
        g.photourl = data.photourl;
      }).then((x) => _ok = true);
      return _ok;
    } catch (e) {
      return false;
    }
  }

   Future<String> currentUser() async {
     try {
        FirebaseUser user = await _firebaseAuth.currentUser();
      return user != null ? user.email : null;
     }
     catch(e){
       return null;
     }
     
    }
  Future<bool> isLogged() async {
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
  
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Principal');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        color: Color(0xff1c2634),
        child: new Center(
          child: new Image.asset('images/logo_white.png', height: 313, width: 256,),
      ),
      )
    );
  }
}