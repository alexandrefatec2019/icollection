import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/Produto_Services.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:icollection/model/usuarioModel.dart';

import 'package:show_dialog/show_dialog.dart' as dialog;
//Futuramente será formatado, mas ja traz a lista dos produtos do firabase e a rolagem funciona

class ListarProdutosPrincipal extends StatefulWidget {
  @override
  _ListarProdutosPrincipalState createState() =>
      new _ListarProdutosPrincipalState();
}

class _ListarProdutosPrincipalState extends State<ListarProdutosPrincipal> {
  List<ListaProdutoModel> items;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> noteSub;

  @override
  initState() {
    super.initState();

    items = List();

    noteSub = db.getNoteList().listen((QuerySnapshot snapshot) {
      final List<ListaProdutoModel> notes = snapshot.documents
          .map((documentSnapshot) =>
              ListaProdutoModel.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = notes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ProdutoLista').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return FutureBuilder(
              future: call(document.data['usuario']),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                return Center(
                    child: Row(
                  children: <Widget>[
                    avatar(snapshot.data.photourl),
                    nomeUsuario(snapshot.data.nome),
                    imagemProduto(document.data['image'][0])
                    //
                  ],
                ));
              },
            );
          }).toList(),
        );
      },
    );
  }
}

Future<UsuarioModel> call(DocumentReference doc) {
//  return 'xxxxxxxxxxxxxxxxxxxxxxx3233333333333333';
  return doc.get().then((onValue) => UsuarioModel.map(onValue));
}

Widget imagemProduto(String imgProduto) {
  print(imgProduto);
  return Container(
      width: 205.0,
      height: 205.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: CachedNetworkImageProvider(imgProduto),
        ),
      ));
}

Widget nomeUsuario(String nomeUsuario) {
  return Container(
      child: Padding(
    padding: EdgeInsets.only(left: 5),
    child: Text(nomeUsuario,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
  ));
}

Widget avatar(String imagemUsuario) {
  return Container(
      width: 45.0,
      height: 45.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: CachedNetworkImageProvider(imagemUsuario),
        ),
      ));
}
