import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icollection/Usuario/Cadastro.dart';
import 'package:icollection/datas/produtodata.dart';
import 'package:firebase_database/firebase_database.dart';

class ProdutoDetalhe extends StatefulWidget {
  //recebe o id do produoto
  final String id;
  ProdutoDetalhe(this.id);

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
          'Funko Venom',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xff1c2634),
      ),
      body: _buildProdutoDetalhes(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
                
        },
        backgroundColor: Color.fromRGBO(255, 105, 105, 100),
        label: Text('TENHO INTERESSE'),
        icon: Icon(Icons.thumb_up),
      ),
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
        images: [
          new NetworkImage(
              'https://cdn.shopify.com/s/files/1/1917/3817/products/t_fk32685_900x.jpg?v=1541017729'),
          new NetworkImage(
              'https://http2.mlstatic.com/funko-pop-marvel-venom-venom-363-D_NQ_NP_741023-MLB29295981920_012019-F.jpg'),
          new NetworkImage(
              'https://www.picclickimg.com/d/l400/pict/223325939595_/Funko-POP-Venom-363-Marvel-Eddie-Brock-Symbiote.jpg'),
          new NetworkImage(
              'https://static3.tcdn.com.br/img/img_prod/460977/estatua_gollum_e_smeagol_o_senhor_dos_aneis_the_lord_of_the_rings_premium_format_sideshow_34871_1_20180720182614.jpg'),
        ],
        indicatorBgPadding: 2.5,
      ),
    );
  }
  _buildRowPrecoLikeWidgets(){
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('R\$ 999', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blue[300], 
          ),
        ),
        ],
        //TODO - Inserir botão like abaixo / Ja esta com espaçamento entre os elementos


      ),
      ),
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
                  "PRODUTO",
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
                              "Alexandre",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "(17)9.9999-9999",
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
                              "REGIÃO:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
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
                              "São Paulo - SP",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "gruposjrp@gmail.com",
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
                              "CÓDIGO:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "CONDIÇÃO:",
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
                              "0123456789",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Novo",
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
                              "Plástico (Vinil)",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Indisponível",
                              style: TextStyle(
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
