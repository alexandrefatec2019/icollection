import 'package:flutter/material.dart';
import 'package:icollection/tabs/categoriatab.dart';


class Categoria extends StatelessWidget {
  const Categoria({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        // Scaffold(
        //   body: HomeTab(),
        //   //drawer: ,
        // ),
        Scaffold(
          appBar: AppBar(
           title: Text('Categorias'),
           backgroundColor: Color(0xff1c2634),
          //  title: Text(snapshot.data["title"])
          centerTitle: true,
          ),
          body: CategoriaTab(),
        )
      ], 
    );
  }
}