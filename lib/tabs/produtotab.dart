import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/tile/categoria_tile.dart';

class ProdutoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("Produtos").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else{
          var dividedTiles = ListTile.divideTiles(
            tiles: snapshot.data.documents.map((doc) {
              return CategoriaTile(doc);
            }).toList(),
            color: Colors.grey).toList();
        return ListView(
          children: dividedTiles,
        );
        }
      }
    );
  }
}