import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/tabs/categoriatab.dart';

class Categoria extends StatelessWidget {
  const Categoria(DocumentSnapshot snapshot, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
           title: Text('Categorias'),
           backgroundColor: Color(0xff1c2634),
          centerTitle: true,
          ),
          body: CategoriaTab(),
        )
      ], 
    );
  }
}