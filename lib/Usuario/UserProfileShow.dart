import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icollection/model/usuarioModel.dart';

class MostraPerfilUsuario extends StatelessWidget {
  final UsuarioModel user;
  final String urlproduto;
  MostraPerfilUsuario(this.user, this.urlproduto);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          //foregroundDecoration: ,
          height: MediaQuery.of(context).size.height / 2,
          //padding: const EdgeInsets.all(8.0),
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         fit: BoxFit.fitWidth,
          //         alignment: FractionalOffset.topCenter,
          //         image: CachedNetworkImageProvider(urlproduto))),
          child: Column(children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    //Imagem do fundo (produto)
                    Center(
                        child: new AspectRatio(
                            aspectRatio: 100 / 34,
                            child: new Container(
                                decoration: new BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  alignment: FractionalOffset.center,
                                  image:
                                      CachedNetworkImageProvider(urlproduto)),
                              shape: BoxShape.rectangle,
                              color: Colors.orange,
                            )))),

                    //Avatar do usuario
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 30),
                        child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(user.photourl),
                          foregroundColor: Colors.white,
                        ),
                        width: 120.0,
                        height: 120.0,
                        padding: const EdgeInsets.all(5.0), // borde width
                        decoration: new BoxDecoration(
                          color: const Color(0xFFFFFFFF), // border color
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    //FIM Avatar do usuario
                  ],
                ),
                Text(user.nome,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ))
              ],
            )
          ])),
      contentPadding: EdgeInsets.all(0.0),
    );
  }
}
