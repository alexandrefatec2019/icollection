import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListarProdutos extends StatelessWidget {
  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['nome']),
      subtitle: Text(document['nome']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('Teste').snapshots(),
      //print an integer every 2secs, 10 times
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading..");
        }
        return ListView.builder(
          itemExtent: 80.0,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return _buildList(context, snapshot.data.documents[index]);
          },
        );
      },
    );
  }
}
