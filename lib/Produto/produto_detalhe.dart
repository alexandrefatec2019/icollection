import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:icollection/Usuario/Cadastro.dart';
import 'package:icollection/Usuario/MostrarTelaAuth.dart';
import 'package:icollection/datas/produtodata.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:icollection/model/usuarioModel.dart';
import '../Login/Tela_Auth.dart';
import 'package:icollection/VariaveisGlobais/UsuarioGlobal.dart' as g;
import '../Login/auth.dart';
import '../Principal.dart';


Autentica auth = Autentica();


class ProdutoDetalhe extends StatefulWidget {
  //recebe o id do produto
  final UsuarioModel usuarioModel;
  final ListaProdutoModel produtoModel;
  ProdutoDetalhe(this.usuarioModel, this.produtoModel);

  @override
  _ProdutoDetalheState createState() => _ProdutoDetalheState(snapshot, produto);
  DocumentSnapshot snapshot;
  ProdutoData produto;
}

class _ProdutoDetalheState extends State<ProdutoDetalhe>
    with TickerProviderStateMixin {
  final DocumentSnapshot snapshot;
  final ProdutoData produto;
  _ProdutoDetalheState(this.snapshot, this.produto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.produtoModel.nomeproduto,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xff1c2634),
      ),
      body: _buildProdutoDetalhes(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _mostraMSG();
        },
        backgroundColor: Color.fromRGBO(255, 105, 105, 100),
        label: Text('TENHO INTERESSE'),
        icon: Icon(Icons.thumb_up),
      ),
    );
  }

  //Voce precisa esta autenticado
  void _mostraMSG() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Autenticação necessária'),
            content: setupAlertDialoadContainer(),
          );
        });
  }

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 200.0, // Change as per your requirement
      width: 200.0, // Change as per your requirement
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GoogleSignInButton(

                  text: '  Google Login   ',
                    darkMode: true,
                    onPressed: () async {
                      print(g.dadosUser);
                      await auth.googleLogin().then((value) {
                        Navigator.of(context).push(
                          //
                          
                            //Var g.dadosUser verifica se o usuario ja esta cadastrado ou nao no db
                            MaterialPageRoute(builder: (context) => CadDados(g.dadosUser)));
                      });
                    }),
                FacebookSignInButton(
                  
                  text: 'Facebook Login',
                  onPressed: () {
                  auth.facebookLogin().whenComplete(() {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Principal()));
                  });
                }),
              ],
          )),
    );
  }

  _buildProdutoDetalhes(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(2.0),
          child: Card(
            elevation: 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //TODO - Carregar todos os builds
                _buildImagensProdutoWidgets(),
                SizedBox(
                  height: 12.0,
                ),
                _buildRowPrecoLikeWidgets(),
                _buildTabDetalhesWidgets(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildImagensProdutoWidgets() {
    return SizedBox(
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: Carousel(
        boxFit: BoxFit.contain,
        images: widget.produtoModel.image.map((url) {
          return Image(image: CachedNetworkImageProvider(url));
        }).toList(),
        indicatorBgPadding: 2.5,
      ),
    );
  }

  _buildRowPrecoLikeWidgets() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'R\$'+widget.produtoModel.valor,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue[300],
              ),
            ),
          ],
          //TODO - Inserir botão like abaixo / Ja esta com espaçamento entre os elementos
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5),
          
          child: Text(widget.produtoModel.descricao, 
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700]
              ), maxLines: 3,
              overflow: TextOverflow.ellipsis,
          )
          )
        ],
      )
        ],
      )
    );
  }

  _buildTabDetalhesWidgets() {
    TabController tabController = new TabController(length: 2, vsync: this);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "ANUNCIANTE",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "DETALHES",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          //TODO ProdutoDetalhe - TAB PRODUTO
          // ------------ INICIO LINHA 1 ------------
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "VENDIDO POR:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "CONTATO:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              widget.usuarioModel.nome,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.usuarioModel.telefone,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      // ------------ FIM LINHA 1 ------------

                      // ------------ INICIO LINHA 2 ------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "EMAIL:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          )
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              widget.usuarioModel.email,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        ],
                      ),
                      // --------------- FIM LINHA 2 ----------------
                    ]),
                  ],
                ),
                ListView(
                  children: <Widget>[
                    Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //TODO ProdutoDetalhe - TAB DETALHE
                          Container(
                            child: Text(
                              "CONDIÇÃO:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "CATEGORIA:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              widget.produtoModel.estado,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.produtoModel.categoria,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      // ------------ FIM LINHA 1 ------------

                      // ------------ INICIO LINHA 2 ------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "MATERIAL:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "TROCA:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          )
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              widget.produtoModel.material,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            child: 
                              widget.produtoModel.troca == 'false' ? 
                              Text('Não disponível', style: TextStyle(
                                color: Colors.grey[600],
                                ),
                              ) : 
                              Text('Disponível', style: TextStyle(
                                color: Colors.grey[600],
                                ),
                              ),
                              
                          )
                        ],
                      ),
                      // ------------ FIM LINHA 2 ------------
                    ]),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
