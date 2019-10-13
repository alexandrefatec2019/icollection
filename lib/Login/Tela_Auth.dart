import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import '../MenuLateral.dart';
import '../Principal.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(size: 150),
                SizedBox(height: 50),
                GoogleSignInButton(
                    darkMode: true,
                    onPressed: () {
                      auth.googleLogin().whenComplete(() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Principal()));
                      });
                    })
              ]),
        ),
      ),
    );
  }
}