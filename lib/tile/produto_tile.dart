import 'package:flutter/material.dart';
import 'package:icollection/datas/produtodata.dart';

class ProdutoTile extends StatelessWidget {
  final String type;
  final ProdutoData produto;
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
                produto.imagens[0],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(produto.nome, style: TextStyle(
                        fontWeight: FontWeight.w200
                      ),
                    ),
                    Text('R\$ ${produto.valor}',  //Text('R\$ ${produto.valor.toStringAsFixed(2)}') -- valor como double, 2 casas depois da virgula
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

        )
      ),
    );
  }
}