import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:icollection/tile/produto_tile.dart';

class Produto extends StatelessWidget {
  final DocumentSnapshot snapshot;
  Produto(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1c2634),
          title: Text(snapshot.data[
              'title']), //- Pegar o titulo de acordo com a categoria escolhida
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        //Carregar as info de acordo com a categoria (EM PROCESSO)
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("ProdutoLista")
              .where('categoria', isEqualTo: snapshot.documentID)
              .getDocuments(),
          builder: (context, snapshotProduto) {
            
            if (!snapshotProduto.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    GridView.builder(
                      padding: EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 0.55),
                      itemCount: snapshotProduto.data.documents.length,
                      itemBuilder: (context, index) {
                        return ProdutoTile(
                            'grid',
                            ListaProdutoModel.fromMap(snapshotProduto.data.documents[index].data));
                      },
                    ),
                    ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshotProduto.data.documents.length,
                      itemBuilder: (context, index) {
                        return ProdutoTile(
                            'list',
                            ListaProdutoModel.fromMap(
                                snapshotProduto.data.documents[index].data));
                      },
                    ),
                  ]);
            }
          },
        ),
      ),
    );
  }
}
