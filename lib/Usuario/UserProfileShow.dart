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
                        child: AspectRatio(
                            aspectRatio: 100 / 34,
                            child: Container(
                                decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 5.0,
                              ),
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
                    )),
                    _faixa(user)
              ],
            )
          ])),
      contentPadding: EdgeInsets.all(0.0),
    );
  }
}

 Widget _faixa(UsuarioModel user) {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 10.0, left: 4, right: 4),
      decoration: BoxDecoration(
        color: Colors.black12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Produtos", '12'),
          _buildStatItem("Like", '21'),
        //  _buildStatItem("Scores", '1'),
        ],
      ),
    );
  }

Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }