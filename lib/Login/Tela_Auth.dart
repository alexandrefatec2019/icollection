import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:icollection/Login/auth.dart';
import 'package:icollection/Usuario/Cadastro.dart';


import '../Principal.dart';

Autentica auth = Autentica();

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GoogleSignInButton(
                  text: 'Google Login',
                    darkMode: true,
                    onPressed: () async {
                      await auth.googleLogin().then((value) {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CadDados()));
                      });
                    }),
                FacebookSignInButton(
                  text: 'Facebook Login',
                  onPressed: () {
                  auth.facebookLogin().whenComplete(() {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Principal()));
                  });
                }),
              ],
          )),
    );
  }
}