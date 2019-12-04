import 'package:flutter/material.dart';
import 'package:icollection/model/listaprodutoModel.dart';

class ProdutoTile extends StatelessWidget {
  final String type;
  final ListaProdutoModel produto;
  ProdutoTile(this.type, this.produto);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: type == 'grid' ?
        Column(
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
                    Text(produto.nomeproduto, style: TextStyle(
                        fontWeight: FontWeight.w200
                      ),
                    ),
                    Text('R\$ ${produto.valor}',
                        style: TextStyle(
                          color: Colors.blue[200],
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold
                        ),
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
                    Text(produto.nomeproduto, style: TextStyle(
                        fontWeight: FontWeight.w200
                      ),
                    ),
                    Text('R\$ ${produto.valor}',
                        style: TextStyle(
                          color: Colors.blue[200],
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold
                        ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}