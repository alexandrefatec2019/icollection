import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/Produto_Services.dart';
import 'package:icollection/Produto/note_screen.dart';
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
            //NetworkImage('${items[position].image[0]}')),
            itemCount: items.length,
            //padding: const EdgeInsets.all(0.0),
            itemBuilder: (context, position) {
              return Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                  child: SizedBox(
                    //tamanho da faixa branca onde vai avatar usuario e nome e mais um botao talvez
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        //Avatar do usuario
                        Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  '${items[position].imageUsuario}'),
                            ),
                          ),
                        ),
                        //Nome do usuario
                        Container(
                            child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('${items[position].nomeUsuario}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black)),
                        )),
                        //Icon
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: IconButton(
                                        icon: Icon(Icons.more_vert),
                                        iconSize: 30,
                                        tooltip: 'Increase volume by 10',
                                        onPressed: () {
                                          dialog.aboutDialog(
                                              context,
                                              'oie ' +
                                                  '${items[position].nomeUsuario}',
                                              'xxxx');
                                        }))))
                      ],
                    ),
                  ),
                ),
                //Imagem do produto
                Container(
                    //TODO ver depois para deixar o tamanho maximo
                    height: MediaQuery.of(context).size.height / 2,
                    child: AspectRatio(
                        aspectRatio: 500 / 500,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    alignment: FractionalOffset.topCenter,
                                    image: CachedNetworkImageProvider(
                                        '${items[position].image[0]}')),
                              ),
                            ),
                          ],
                        ))),
                SizedBox(
                  height: 40,
                  //width: 300,
                  child: Row(
                    children: <Widget>[
                      Container(
                          child: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('${items[position].nomeproduto}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black)),
                      )),
                      
                    ],
                  ),
                  
                ),
                Divider(
                        thickness: 1,
                        color: Colors.black,
                      )
              ]);
            }));
  }
}
