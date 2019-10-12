import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Autentica {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  //Login Google
  Future<bool> googleLogin() async {
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
      
      //TODO talvez fazer retornoar todos os dados do user apos o login
      return true;
    } catch (e) {
      return false;
    }
  }

  //Logout Google
  Future<void> googleLogout() async {
    //print('ok');

    await _auth.signOut();
    await _googleSignIn.signOut();
    //Fecha app
    SystemNavigator.pop();
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
