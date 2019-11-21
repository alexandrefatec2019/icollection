import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/novoproduto.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'VariaveisGlobais/UsuarioGlobal.dart' as g;

class Vendas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1c2634),
        title: Text('Vendas'),
        centerTitle: true,
      ),
      body: ListaProdutos(),
      //TODO - Botão Novo anuncio
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NovoProduto(null),
              ));
        },
        icon: Icon(Icons.add),
        label: Text('Novo Anúncio'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ListaProdutos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('ProdutoLista')
          .where('usuario', isEqualTo: g.usuarioReferencia)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return Card(
                    child: Row(
                  children: <Widget>[
                    imageProduto(document.data['image']),
                    Text(document.data['descricao']),
                  ],
                ));
              }).toList(),
            );
        }
      },
    );
  }
}

Widget imageProduto(List url) {
  return SizedBox(
      height: 200,
      child: GestureDetector(
        onTap: null,
        child: Container(
          width: 170.0,
          //height: 170.0,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                fit: BoxFit.fill, image: CachedNetworkImageProvider(url[0])),
          ),
        ),
      ));
}
