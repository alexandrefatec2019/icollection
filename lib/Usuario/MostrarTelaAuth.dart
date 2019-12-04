import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:icollection/model/usuarioModel.dart';

import 'package:icollection/VariaveisGlobais/UsuarioGlobal.dart' as g;

import '../Login/auth.dart';


Autentica auth = Autentica();


class MostraTelaAuth extends StatelessWidget {
  
  MostraTelaAuth();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(

          height: MediaQuery.of(context).size.height / 2,
          child: Column(children: <Widget>[
            GoogleSignInButton(),
            Text('oie')
          ])),
      contentPadding: EdgeInsets.all(0.0),
      
    );
  }
}

 
Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, 
      width: 300.0, 
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Error'),
          );
        },
      ),
    );
  }