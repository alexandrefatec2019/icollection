import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/produto_detalhe.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:icollection/model/usuarioModel.dart';
import 'package:page_transition/page_transition.dart';

class ProdutoTile extends StatelessWidget {
  final String type;
  final ListaProdutoModel produto;
  ProdutoTile(this.type, this.produto);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //passa a referencia do usuario e retorna dados do usuario que postou o produto
        future: readDadosUsuario(produto.usuario),
        builder: (ctx, snapshotUsuario) {
          if (!snapshotUsuario.hasData)
            //aqui pode se carregar alguma animação para quando estiver carregando a lista
            return Center(
              child: null,
            );
          return card(type, produto, snapshotUsuario.data, context);
        });
  }

  Widget card(String type, ListaProdutoModel produto, UsuarioModel user,
      BuildContext context) {


    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                //Passa os dados do usuario e do produto
                child: ProdutoDetalhe(user, produto))
            // MaterialPageRoute(
            //   builder: (context, ) => ProdutoDetalhe(id),
            // )
            );
      },
      child: Card(
          child: type == 'grid'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.8,
                      child: Image.network(
                        produto.image[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              produto.nomeproduto,
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                            Text(
                              'R\$ ${produto.valor}',
                              style: TextStyle(
                                  color: Colors.blue[200],
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Image.network(
                        produto.image[0],
                        fit: BoxFit.cover,
                        height: 250.0,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              produto.nomeproduto,
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                            Text(
                              'R\$ ${produto.valor}',
                              style: TextStyle(
                                  color: Colors.blue[200],
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
    );
  }

//Faz a leitura da referencia e traz em lista
  Future<UsuarioModel> readDadosUsuario(DocumentReference doc) {
    return doc.get().then((onValue) => UsuarioModel.map(onValue));
  }
}
