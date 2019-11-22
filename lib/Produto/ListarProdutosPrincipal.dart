import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/produtoDATA.dart';
import 'package:icollection/Produto/produto_detalhe.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:icollection/model/usuarioModel.dart';
import 'package:show_dialog/show_dialog.dart' as dialog;
//Futuramente será formatado, mas ja traz a lista dos produtos do firabase e a rolagem funciona

class ListarProdutosPrincipal extends StatefulWidget {
  @override
  _ListarProdutosPrincipalState createState() =>
      new _ListarProdutosPrincipalState();
}

class _ListarProdutosPrincipalState extends State<ListarProdutosPrincipal> {
  List<ListaProdutoModel> items;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('ProdutoLista')
          .
          //.where('status', isEqualTo: true).
          snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return FutureBuilder(
              future: call(document.data['usuario']),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                return Center(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        avatar(snapshot.data.photourl),
                                        nomeUsuario(snapshot.data.nome),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(
                            child: botaoPerfil('usuario', context),
                          )
                        ],
                      ),
                      imagemProduto(document.data['image'], document['id']),
                      Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 5, right: 10),
                        child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(document.data['nomeproduto'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          Text('R\$'+document.data['valor'],  //Text('R\$ ${produto.valor.toStringAsFixed(2)}') -- valor como double, 2 casas depois da virgula
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                        ),
                        )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(document.data['descricao'], style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),),
                        ],
                      ),
                      // TODO - BOTÃO DE ADD AOS FAVORITOS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.star),
                            highlightColor: Colors.yellow[300],
                            splashColor: Colors.grey[300],
                            disabledColor: Colors.grey,
                            onPressed: (){
                              
                            },
                          )
                        ],
                      ),
                        ],
                      )
                      ),
                      Divider(
                        color: Colors.grey[300],
                        indent: 15,
                        endIndent: 15,
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}

Future<void> likebutton(DocumentReference u,String idProduto) async {
  final TransactionHandler transaction = (Transaction tx) async {
    DocumentSnapshot freshSnap = await tx.get(u);
    await tx.update(freshSnap.reference, {
      'like': freshSnap['like'] ?? 0 + 1,
    });
    List<String> users = [idProduto]; //userId
    await tx.update(freshSnap.reference, {
      'userLike': FieldValue.arrayUnion(users),
    });
  };

  return Firestore.instance
        .runTransaction(transaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
}

//Faz a leitura da referencia e traz em lista
Future<UsuarioModel> call(DocumentReference doc) {
  return doc.get().then((onValue) => UsuarioModel.map(onValue));
}

Widget imagemProduto(List imgProduto, String id) {
  int n = imgProduto.length.toInt();
  return CarouselSlider(
      enlargeCenterPage: true,
      height: 400.0,
      items: imgProduto.skip(0).take(n).map((i) {
        return Builder(builder: (BuildContext context) {
          return Container(
              //TODO ver depois para deixar o tamanho maximo
              height: MediaQuery.of(context).size.height / 2,
              child: AspectRatio(
                  aspectRatio: 500 / 500,
                  child: Stack(children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProdutoDetalhe(id),
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                alignment: FractionalOffset.topCenter,
                                image: CachedNetworkImageProvider(i)),
                          ),
                        )),
                  ])));
        });
      }).toList());
}

Widget botaoPerfil(String usuario, BuildContext context) {
  return Container(
      //alignment: Alignment.centerRight,
      child: Padding(
          padding: EdgeInsets.only(right: 0),
          child: IconButton(
              icon: Icon(Icons.more_vert),
              iconSize: 30,
              tooltip: 'Increase volume by 10',
              onPressed: () {
                dialog.aboutDialog(context, usuario.toString(), 'xxxx');
              })));
}

Widget nomeUsuario(String nomeUsuario) {
  return Container(
      child: Padding(
    padding: EdgeInsets.only(left: 5),
    child: Text(nomeUsuario,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
  ));
}

Widget avatar(String imagemUsuario) {
  return Container(
      width: 35.0,
      height: 35.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: CachedNetworkImageProvider(imagemUsuario),
        ),
      ));
}
