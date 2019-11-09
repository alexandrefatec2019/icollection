import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/Produto_Services.dart';
import 'package:icollection/Produto/note_screen.dart';
import 'package:icollection/model/listaprodutoModel.dart';

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
  void initState() {
    super.initState();

    items = new List();

    noteSub?.cancel();
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
  void dispose() {
    noteSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.all(1.0),
          itemBuilder: (context, position) {
            return Card(
              semanticContainer: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: AspectRatio(
                aspectRatio: 500 / 500,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(20.0)),
                        //topRight: const Radius.circular(20.0)),
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            //Define aonde vai cortar a imagem !!
                            alignment: FractionalOffset.topCenter,
                            image: NetworkImage('${items[position].image[0]}')),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(const Radius.circular(20.0)),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.transparent],
                            stops: [0.2, 0.3]),
                      ),
                    ),
                    Container(
                        //Alinhamento do texto
                        alignment: Alignment(-1.0, 1.0),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('${items[position].nomeproduto}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 34,
                                  color: Colors.white)),
                        ))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
