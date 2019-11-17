import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/Produto_Services.dart';
import 'package:icollection/model/listaprodutoModel.dart';

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
          

         // nesse caso, ele vai refazer a chamada, porque toda vez que a função facaAlgo é chamada, ela retorna um novo objeto
         // da classe Future
       //  future: facaAlgo(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          return Center(
            child: Text(" fiz : ${snapshot.data}"+ 'xxxxx' +document.data['descricao']),
          );
        },
      );
          
          }).toList(),
        );
        
      },
    );
  }
}

Future<String> call(DocumentReference doc) {
//  return 'xxxxxxxxxxxxxxxxxxxxxxx3233333333333333';
  return  doc.get().then((onValue) =>  onValue.data['nome'].toString());
}