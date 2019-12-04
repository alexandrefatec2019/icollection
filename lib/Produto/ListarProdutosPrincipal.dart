import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:icollection/Produto/produtoDATA.dart';
import 'package:icollection/Produto/produto_detalhe.dart';
import 'package:icollection/Usuario/UserProfileShow.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:icollection/model/usuarioModel.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:like_button/like_button.dart';
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
        return ListView(
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
                            
                            child: botaoPerfil(snapshot.data, context, document.data['image']),
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
                                      var prodRef = document.reference;
                                      var prodID = document.documentID;
                                      //checkUserLike(prodRef);
                                      likebutton(userRef, prodID, prodRef);
                                      checkUserLike(document.documentID);
                                    },
                                  ),
                                  ikebutton(document.documentID)
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

Widget ikebutton(String idProduto) {
  return FutureBuilder(
      future: checkUserLike(idProduto),
      builder: (ctx, snapshot) {
        print(snapshot.error);
        return Text('oe' + snapshot.data.toString());
      });
}

//Verifica se o usuario já curtiu o produto
//e returna bool
checkUserLike(String idProduto) async {
  QuerySnapshot verifica = await Firestore.instance
      .collection('Usuario')
      .where('produtosLike', arrayContains: idProduto)
      .getDocuments();

  bool a = verifica.documents.length == 1;
  //print('cccccccccccccccccccccc' + a.toString());
  return a;
}

Future likebutton(DocumentReference u, String idProduto, DocumentReference p) {
  final TransactionHandler transaction = (Transaction tx) async {
    DocumentSnapshot user = await tx.get(u);
    DocumentSnapshot produto = await tx.get(p);

    //Verifica se o usuario ja curtiu o produto
    QuerySnapshot verifica = await Firestore.instance
        .collection('Usuario')
        .where('produtosLike', arrayContains: idProduto)
        .getDocuments();

    //Adiciona o id do produto na Lista do usuario
    List<String> users = [idProduto];

    if (verifica.documents.length == 0) {
      //Adiciona o produto que o usuario curtiu na lista
      //produtosLike no documento do usuario
      await tx.update(user.reference, {
        'produtosLike': FieldValue.arrayUnion(users),
      });
      //contabiliza +1 no Like do produto
      await tx.update(produto.reference, {
        'like': (produto.data['like'] ?? 0) + 1,
      });
    }
    //Caso contrario remove da Lista de curtir, e -1 no like do produto
    else {
      await tx.update(produto.reference, {
        'like': (produto.data['like'] ?? 0) - 1,
      });
      await tx.update(user.reference, {
        'produtosLike': FieldValue.arrayRemove(users),
      });
    }
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
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ProdutoDetalhe(id))
                              // MaterialPageRoute(
                              //   builder: (context, ) => ProdutoDetalhe(id),
                              // )
                              );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                alignment: FractionalOffset.center,
                                image: CachedNetworkImageProvider(i)),
                          ),
                        )),
                  ])));
        });
      }).toList());
}

Widget botaoPerfil(UsuarioModel usuario, BuildContext context, List urlProduto) {
  return Container(
      //alignment: Alignment.centerRight,
      child: Padding(
          padding: EdgeInsets.only(right: 0),
          child: IconButton(
              icon: Icon(Icons.more_vert),
              iconSize: 30,
              tooltip: '',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return MostraPerfilUsuario(usuario, urlProduto[0]);
                    });
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

// Widget buttonLike() {
//   double buttonSize = 40.0;
//   return LikeButton(
//     size: buttonSize,
//     circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
//     bubblesColor: BubblesColor(
//       dotPrimaryColor: Color(0xff33b5e5),
//       dotSecondaryColor: Color(0xff0099cc),
//     ),
//     likeBuilder: (bool isLiked) {
//       return Icon(
//         Icons.star_border,
//         color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
//         size: buttonSize,
//       );
//     },
//     likeCount: 665,
//     countBuilder: (int count, bool isLiked, String text) {
//       var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
//       Widget result;
//       if (count == 0) {
//         result = Text(
//           "love",
//           style: TextStyle(color: color),
//         );
//       } else
//         result = Text(
//           text,
//           style: TextStyle(color: color),
//         );
//       return result;
//     },
//   );
// }
class GradientDialogState extends State<ListarProdutosPrincipal> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: new BoxDecoration(
            ),
        child: Text('oe'),

      ),
      contentPadding: EdgeInsets.all(0.0),
    );
  }
}