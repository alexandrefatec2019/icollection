import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:icollection/AppBar.dart';
import 'package:icollection/Firestore/Leitura.dart';
import 'package:icollection/Login/auth.dart';
//Arquivo onde esta todos os items do menu Lateral
import 'package:icollection/Login/Tela_Auth.dart';
import 'package:icollection/MenuLateral.dart';

class Produto extends StatefulWidget {
  Produto({Key key}) : super(key: key);

  _ProdutoState createState() => _ProdutoState();
}

class _ProdutoState extends State<Produto> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
       length: 2,
       child: Scaffold(
         appBar: AppBar(
           title: Text('Produtos'),
           backgroundColor: Color(0xff1c2634),
          //  title: Text(snapshot.data["title"]) - Pegar o titulo de acordo com a categoria escolhida
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on),),
              Tab(icon: Icon(Icons.list),),
            ],
          ),
         ),
         body: TabBarView(
           physics: NeverScrollableScrollPhysics(),
           children: <Widget>[
            Container(
              color: Colors.red,
              ),
            Container(
              color: Colors.green,
              ),
           ]
            ),
            //Carregar as info de acordo com a categoria (EM PROCESSO)
        // body: FutureBuilder<QuerySnapshot>(
        //   builder: null,
        // ),




        //Japa: Não sei q esquema vc usou no menu lateral pq não entendi nada..
           //drawer: getCustomContainer(),
         ),
         
       );
       
  }
  
}