import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Principal.dart';
import 'package:icollection/Usuario/Cadastro.dart';
import 'Login/Tela_Auth.dart';
import 'Usuario/UsuarioDATA.dart';
//Variaveis globais! (em teste)
import 'VariaveisGlobais/UsuarioGlobal.dart' as g;

void main()  {
  //WidgetsFlutterBinding.ensureInitialized();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  //TODO reativar cache
  // Firestore.instance.settings(
  //   persistenceEnabled: true,
  //   cacheSizeBytes: 1048576
  // );
  
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
//////////////////////////////////////////////////////////////////
  }});
  

  //Define a variavel referencia

  // final bool isLogged = await _auth.isLogged();
  // final Icollection icollection = Icollection(
  //   initialRoute: isLogged ? '/' : '/Login',
  // );

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
      initialRoute: '/',
      routes: {
        //Tela principal onde vai listar os produtos anunciados
        '/': (context) => Principal(),
        //Tela de login ao clicar no botao menu
        '/Login': (context) => LoginPage(),
        '/CadastroUsuario': (context) => CadDados(),
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
      //print('\n\n\n\n\n\n\n\n\n catch main = '+e.toString());
      return false;
    }

    // nome = _u.nome;
    // email = _u.email;
    // cpfcnpj = _u.cpfcnpj;
    // telefone = _u.telefone;
    // _photoUrl = _u.photourl;
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
