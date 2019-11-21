import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icollection/model/usuarioModel.dart';
//Variaveis globais! (em teste)
import '../VariaveisGlobais/UsuarioGlobal.dart' as g;

class Autentica {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //Salvar dados apos autenticar
  final Firestore _fireStore = Firestore();

  final FacebookLogin _facebookSignIn = FacebookLogin();

  String name;
  String email;
  String imageUrl;

  //Retorna dados do usuario do Database
  Future<UsuarioModel> userData() async {
    final CollectionReference usuarioCollection =
        Firestore.instance.collection('Usuario');

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //Le o documento do usuario
    var document = usuarioCollection.document(user.email).get();
    return await document.then((r) {
      return UsuarioModel.map(r);
    });
  }

  //Login Google
  Future<UsuarioModel> googleLogin() async {
    print('Entrou no googleLogin');
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();

      assert(user.uid == currentUser.uid);

      assert(user.email != null);
      //assert(user?.phoneNumber != null);

      assert(user.displayName != null);
      //assert(user.photoUrl != null);

      //Define as variaveis globais na primeira autenticacao!!
      g.email = user.email;
      g.nome = user.displayName;
      g.photourl = user.photoUrl;
       g.usuarioReferencia =
           Firestore.instance.collection('Usuario').document(user.email);

      return UsuarioModel(
          user.email, user.displayName, user.email, '', '', user.photoUrl);
    } catch (e) {
      print('Deu erro na autenticacao exeption = '+e.toString());
      googleLogout();
      return null;
    }
  }

  Future<bool> facebookLogin() async {
    try {
      final facebookLoginResult =
          await _facebookSignIn.logIn(['email', 'public_profile']);
      FacebookAccessToken myToken = facebookLoginResult.accessToken;

      ///assuming sucess in FacebookLoginStatus.loggedIn
      /// we use FacebookAuthProvider class to get a credential from accessToken
      /// this will return an AuthCredential object that we will use to auth in firebase
      AuthCredential credential =
          FacebookAuthProvider.getCredential(accessToken: myToken.token);

// this line do auth in firebase with your facebook credential.
      FirebaseUser firebaseUser =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      //TODO talvez fazer retornoar todos os dados do user apos o login
      return true;
    } catch (e) {
      return false;
    }
  }

  //Logout Google
  Future<void> googleLogout() async {
     FirebaseAuth.instance.signOut();
    await _auth.signOut();
    await _googleSignIn.signOut();
    //Fecha app
    SystemNavigator.pop();
  }

  Future<String> googleUser() async {
    return name;
  }
}

// class GoogleSignInAccount implements GoogleIdentity {
//   GoogleSignInAccount._(this._googleSignIn, Map<String, dynamic> data)
//       : displayName = data['displayName'],
//         email = data['email'],
//         id = data['id'],
//         photoUrl = data['photoUrl'],
//         _idToken = data['idToken'] {
//     assert(id != null);
//   }

Future<bool> userCheck(String uid) async {
  final QuerySnapshot result = await Firestore.instance
      .collection('Usuario')
      .where('id', isEqualTo: uid)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  return documents.length == 1;
}
