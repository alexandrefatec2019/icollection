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
import 'package:icollection/categoria.dart';
import 'package:icollection/datas/produtodata.dart';
import 'package:icollection/tile/produto_tile.dart';

class Produto extends StatelessWidget {

//   ProdutoState createState() => ProdutoState();
// }

// class ProdutoState extends State<Produto> {
  final DocumentSnapshot snapshot;

  Produto(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
       length: 2,
       child: Scaffold(
         appBar: AppBar(
           //title: Text('Produtos'),
           backgroundColor: Color(0xff1c2634),
          title: Text(snapshot.data['title']), //- Pegar o titulo de acordo com a categoria escolhida
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on),),
              Tab(icon: Icon(Icons.list),),
            ],
          ),
         ),
            //Carregar as info de acordo com a categoria (EM PROCESSO)
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("Produtos").document(snapshot.documentID).collection('itens').getDocuments(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  GridView.builder(
                    padding: EdgeInsets.all(4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 0.55
                    ),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index){
                      return ProdutoTile('grid', ProdutoData.fromDocument(snapshot.data.documents[index]));
                    },
                  ),
                  ListView.builder(
                  padding: EdgeInsets.all(4.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                      return ProdutoTile('list', ProdutoData.fromDocument(snapshot.data.documents[index]));
                    },
                  ),
                ]
              );
            }
          },
        ),

           //drawer: getCustomContainer(),
         ),
         
       );
       
  }
  
}