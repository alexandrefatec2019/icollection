import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/novoproduto.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:page_transition/page_transition.dart';
import '../VariaveisGlobais/UsuarioGlobal.dart' as g;

class Vendas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1c2634),
        title: Text('Produtos Anunciados'),
        centerTitle: true,
      ),
      body: ListaProdutos(),
      //TODO - Botão Novo anuncio
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(type: PageTransitionType.downToUp, child: NovoProduto(null))
              );
        },
        icon: Icon(Icons.add),
        label: Text('Novo Anúncio'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ListaProdutos extends StatelessWidget {
  bool pressed = false;
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
                return InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NovoProduto(
                                ListaProdutoModel.fromMap(document.data)),
                          ));
                    },
                    child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 5,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: imageProduto(document.data['image'],
                                          document.documentID),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(document.data['nomeproduto'],
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300,
                                              )
                                            ),
                                      ],  
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      children: <Widget>[
                                        Text('Estado: '),
                                        Text(document.data['estado'],
                                        
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w200,
                                          )
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4,),
                                    Row(
                                      children: <Widget>[
                                        Text('Troca: '),
                                        document.data['troca'] == 'false' ?
                                          Text('Não disponível', style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w200,
                                          ))
                                          : Text('Disponível', style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w200,
                                          ))
                                      ],
                                    ),
                                    SizedBox(height: 4,),
                                    Row(
                                      children: <Widget>[
                                        Text('Valor: '),
                                        Text('R\$'),
                                        Text(document.data['valor'],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          )
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      
                                      children: <Widget>[
                                        Text('Vendido: '),
                                        pressed == true ? Text('Sim') : Text('Não'),
                                        Switch(
                                          value: true,
                                          onChanged: (value) {
                                            value = false;
                                            pressed = !pressed;
                                            // setState(() {
                                            //   value = false;
                                            // });
                                          },
                                          activeTrackColor: Colors.lightBlueAccent, 
                                          activeColor: Colors.blue,
                                          inactiveTrackColor: Colors.grey,
                                        )
                                      ],
                                    )
                                  ],
                                  ),
                              ),
                            )
                          ],
                        )
                    )
                );
              }
              ).toList(),
            );
        }
      },
    );
  }
}

Widget imageProduto(List url, String id) {
  return SizedBox(
    height: 180,
    child: Center(
      child: AspectRatio(
        aspectRatio: 420 / 451,
        child: Container(
            decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              alignment: FractionalOffset.center,
              image: CachedNetworkImageProvider(url[0])),
        )),
      ),
    ),
  );
}
