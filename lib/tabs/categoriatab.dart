import 'package:flutter/material.dart';

//QuerySnapshot
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icollection/tile/categoria_tile.dart';

class CategoriaTab extends StatelessWidget {
  const CategoriaTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      //future: Firestore.instance.collection["Produtos"].getDocuments(),
      future: Firestore.instance.collection('Produtos').getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          
          return ListView(
            children: snapshot.data.documents.map((doc){
              return CategoriaTile(doc);
            }).toList(),
          );
        }
      },
    );
  }
}