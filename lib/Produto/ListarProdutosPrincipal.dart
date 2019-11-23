import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/produtoDATA.dart';
import 'package:icollection/Produto/produto_detalhe.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:icollection/model/usuarioModel.dart';
import 'package:like_button/like_button.dart';
import 'package:show_dialog/show_dialog.dart' as dialog;

import '../VariaveisGlobais/UsuarioGlobal.dart' as g;
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
          //.where('userLike',arrayContains:  'gruposjrp@gmail.com').
          snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        return 
        ListView(
          physics: BouncingScrollPhysics(),
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return FutureBuilder(
              //passa a referencia do usuario e retorna dados do usuario que postou o produto
              future: readDadosUsuario(document.data['usuario']),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData)
                //aqui pode se carregar alguma animação para quando estiver carregando a lista
                  return Center(
                    child: null,
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
                          padding:
                              EdgeInsets.only(left: 10, bottom: 5, right: 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(document.data['nomeproduto'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                                  Text(
                                    'R\$' +
                                        document.data[
                                            'valor'], //Text('R\$ ${produto.valor.toStringAsFixed(2)}') -- valor como double, 2 casas depois da virgula
                                    style: TextStyle(
                                        color: Colors.blue[300],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    document.data['descricao'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              // TODO - BOTÃO DE ADD AOS FAVORITOS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //buttonLike(),
                                  IconButton(
                                    icon: Icon(Icons.star),
                                    highlightColor: Colors.yellow[300],
                                    splashColor: Colors.grey[300],
                                    disabledColor: Colors.grey,
                                    onPressed: () {
                                      var userRef = g.usuarioReferencia;
                                      var prodRef = document.documentID;
                                      //checkUserLike(prodRef);
                                      likebutton(userRef, prodRef);
                                    },
                                  )
                                ],
                              ),
                            ],
                          )),
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

//Verifica se o usuario já curtiu o produto
checkUserLike(String produtoid) async {
  DocumentReference result =
      Firestore.instance.collection('Usuario').document(g.email);
  return result.get().then((onValue) {
    List<dynamic> l = [];
    l.addAll(onValue.data['produtosLike']);
    if (l.contains(produtoid)) {
      //Returna true se o produto id ja foi curtido
      return true;
    } else {
      print('nao tem');
      return false;
    }
//print(l.map((f)=> f));
  });
}

Future<bool> likebutton(DocumentReference u, String idProduto) {
  final TransactionHandler transaction = (Transaction tx) async {
    DocumentSnapshot user = await tx.get(u);

    // await tx.update(user.reference, {
    //   'like': (user['like'] ?? 0) + 1,
    // });

    List<String> users = [idProduto]; //userId
    await tx.update(user.reference, {
      'produtosLike': FieldValue.arrayUnion(users),
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
Future<UsuarioModel> readDadosUsuario(DocumentReference doc) {
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

Widget buttonLike() {
  double buttonSize = 40.0;
  return LikeButton(
    size: buttonSize,
    circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
    bubblesColor: BubblesColor(
      dotPrimaryColor: Color(0xff33b5e5),
      dotSecondaryColor: Color(0xff0099cc),
    ),
    likeBuilder: (bool isLiked) {
      return Icon(
        Icons.star_border,
        color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
        size: buttonSize,
      );
    },
    likeCount: 665,
    countBuilder: (int count, bool isLiked, String text) {
      var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
      Widget result;
      if (count == 0) {
        result = Text(
          "love",
          style: TextStyle(color: color),
        );
      } else
        result = Text(
          text,
          style: TextStyle(color: color),
        );
      return result;
    },
  );
}
