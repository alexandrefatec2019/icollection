import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icollection/Principal.dart';
import 'package:icollection/Produto/produtoDATA.dart' as prefix0;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icollection/model/listaprodutoModel.dart';

import '../VariaveisGlobais/UsuarioGlobal.dart' as g;
import 'package:icollection/VariaveisGlobais/UsuarioGlobal.dart' as g;

Map<int, dynamic> imgl;

class NovoProduto extends StatefulWidget {
  final ListaProdutoModel product;
  NovoProduto(this.product);

  @override
  _NovoProdutoState createState() => _NovoProdutoState();
}

class _NovoProdutoState extends State<NovoProduto> {
  prefix0.FirebaseFirestoreService db = new prefix0.FirebaseFirestoreService();

  final _formKey = GlobalKey<FormState>();
  DocumentSnapshot snapshot;

  List<dynamic> img = List();

  //TODO - Pagina NovoProduto - Pegar info do Model ou Data do Produto
  String uid;
  String nomeProduto;
  String descricao;
  String valor;
  String material;

  bool troca = false;
  //alterei para string
  String estadoSelecionado; // ainda não inserido
  String categoriaSelecionada;

  List<DropdownMenuItem<int>> estadoList = [];
  // List<DropdownMenuItem<int>> categoriaList = [];

  //teste
  String urlphoto;

  TextEditingController _nomeProduto;
  TextEditingController _descricao;
  TextEditingController _valor;
  TextEditingController _material;
  //TextEditingController _estadoSelecionado;
  TextEditingController _troca;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();

    _nomeProduto = new TextEditingController(text: widget.product?.nomeproduto);
    _descricao = new TextEditingController(text: widget.product?.descricao);
    _valor = new TextEditingController(text: widget.product?.valor);
    _material = new TextEditingController(text: widget.product?.material);
    //_estadoSelecionado =  TextEditingController(text: widget.product?.estado);
    estadoSelecionado = widget.product?.estado ?? '';
    // categoriaSelecionada = widget.product?.categoria ?? '';

    widget.product?.image?.forEach((f) {
      img.add(f);
    });
  }

  void tirarFoto(int n) async {
    var _imagem = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 1280,
        maxWidth: 720);

    // setState(() {
    //   //Add o arquivo na lista
    //   imagens.putIfAbsent(n, () => _imagem);
    //   //this.uploading = true;
    // });

    var endereco =
        '/Produtos/' + g.email + '/' + _imagem.hashCode.toString() + '.jpg';

    var ref = FirebaseStorage().ref().child(endereco);

    StorageUploadTask upload = ref.putFile(_imagem);
    var downloadUrl = await upload.onComplete;
    String url = (await downloadUrl.ref.getDownloadURL());

    setState(() {
      if (url != null) {
        img.add(url);
        //}img.insert(img.length+1, url);
      }
    });
  }

  Map<int, File> imagens = Map();

  bool uploading = false;

  void _categorySelected(String newValueSelected) {
    setState(() {
      this.categoriaSelecionada = newValueSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    String appBarText;
    if (widget.product?.id != null) appBarText = 'Editar Produto';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1c2634),
        title: Text(appBarText ?? 'Novo Produto'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(15.0),
            children: getFormWidget(),
          )),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    //---------- CATEGORIA ----------
    // formWidget.add(DropdownButton<String>(
    //   value: widget.product?.estado,
    //   hint: Text(estadoSelecionado ?? 'Estado do Produto'),
    //   items: <String>['Novo', 'Usado', 'Seminovo', 'Restaurado']
    //       .map((String value) {
    //     return new DropdownMenuItem<String>(
    //       value: value,
    //       child: new Text(value),
    //     );
    //   }).toList(),
    //   onChanged: (_) {
    //     setState(() {
    //       estadoSelecionado = _;
    //     });
    //   },
    //   isExpanded: true,
    // ));


    formWidget.add(new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Produtos').snapshots(),
      builder: (context, snapshot){
        return Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: DropdownButton(
                  hint: new Text(categoriaSelecionada ?? 'Selecione a Categoria'),
                  items: snapshot.data.documents.map((DocumentSnapshot document){
                    return DropdownMenuItem<String>(
                      value: document.data['title'],
                      child: Text(document.data['title']),
                    );
                  },
                  ).toList(),
                  // value: _categoriaSelecionada,
                  onChanged: (_) {
                    setState(() {
                      categoriaSelecionada = _;
                    });
                  },
                  isExpanded: true,
                ),
              )
            ],
          ),
        );
      },
    )
    );

    //---------- NOME DO PRODUTO ----------
    formWidget.add(
      new TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Nome do Produto:',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Digite um Nome para o produto';
          }
        },
        onSaved: (value) => nomeProduto = value,
        controller: _nomeProduto,
      ),
    );

    //---------- DESCRIÇÃO ----------
    formWidget.add(new TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: 'Descrição:',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Escreva a descrição do produto';
        }
      },
      onSaved: (value) => descricao = value,
      controller: _descricao,
    ));

    //---------- MATERIAL ----------
    formWidget.add(new TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Material do Produto:',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Escreva o material do produto';
        }
      },
      onSaved: (value) => material = value,
      controller: _material,
    ));
    formWidget.add(new Padding(padding: EdgeInsets.all(5)));
    //---------- ESTADO DO PRODUTO ----------
    formWidget.add(DropdownButton<String>(
      value: widget.product?.estado,
      hint: Text(estadoSelecionado ?? 'Estado do Produto'),
      items: <String>['Novo', 'Usado', 'Seminovo', 'Restaurado']
          .map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (_) {
        setState(() {
          estadoSelecionado = _;
        });
      },
      isExpanded: true,
    ));

    //---------- VALOR R$ ----------
    formWidget.add(new TextFormField(
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      decoration: InputDecoration(
        labelText: 'Valor (R\$):',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Digite o valor do produto';
        }
      },
      onSaved: (value) => valor = value,
      controller: _valor,
    ));

    //---------- DISPONIBILIDADE TROCA ----------
    formWidget.add(new Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.all(10.0),
          ),
          new Text(
            'Disponibilidade para Troca:',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<bool>(
                // title: const Text('Não'),
                value: false,
                groupValue: troca,
                onChanged: (value) {
                  setState(() {
                    troca = value;
                  });
                },
              ),
              new Text(
                'Não',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              Radio<bool>(
                // title: const Text('Sim'),
                value: true,
                groupValue: troca,
                onChanged: (value) {
                  setState(() {
                    troca = value;
                  });
                },
              ),
              new Text(
                'Sim',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          )
        ],
      ),
    ));

    //---------- IMAGENS ----------
    formWidget.add(new Container(
        child: SizedBox(
      child: Column(
        children: <Widget>[
          new Divider(
            height: 20,
            color: Colors.grey[300],
          ),
          new Padding(
            padding: EdgeInsets.all(5),
          ),
          new Text(
            'Imagens:',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          new Padding(
            padding: EdgeInsets.all(10),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //Lista das imagem do produto

              Expanded(
                child: GridView.count(
                  primary: false,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  children: List.generate(6, (index) {
                    return Center(child: imgProduto(context, index));
                  }),
                ),
              )
            ],
          )
        ],
      ),
    )));

    formWidget.add(new Padding(
      padding: EdgeInsets.all(6),
    ));

    //---------- BOTÃO CONFIRMAR ----------
    formWidget.add(
      new FloatingActionButton.extended(
        onPressed: () {
          // print(_valor.text);
          //Passando o modelo !!
          // saveImage();
          if (widget.product?.id == null) {
            db.criarProduto(ListaProdutoModel(
                uid,
                categoriaSelecionada,
                _nomeProduto.text,
                _descricao.text,
                _material.text,
                estadoSelecionado,
                _valor.text,
                troca,
                true,
                Timestamp.now(),
                Timestamp.now(),
                0,
                img,
                'obs',
                g.usuarioReferencia));
          }else{
              db.updateProduto(ListaProdutoModel(
                widget.product.id,
                categoriaSelecionada,
                _nomeProduto.text,
                _descricao.text,
                _material.text,
                estadoSelecionado,
                _valor.text,
                troca,
                true,
                Timestamp.now(),
                Timestamp.now(),
                0,
                img,
                'obs',
                g.usuarioReferencia));
          }

          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Principal()));
        },
        icon: Icon(Icons.done),
        label: Text('Criar Anúncio'),
        backgroundColor: Colors.green,
      ),
    );
    return formWidget;
  }

  Widget imgProduto(BuildContext context, int n) {
    if (img.length > n)
      return SizedBox(
          //height: 250,
          width: 140,
          child: Stack(
            children: <Widget>[
              Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: CachedNetworkImage(imageUrl: img[n])),
              Positioned(
                  right: 10,
                  top: 6,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        db
                            .removeImagem(widget.product.id, img[n])
                            .then((action) {
                          if (action) img.remove(img[n]);
                        });
                      });
                    },
                  )),
            ],
          ));
    else
      //se nao tiver foto mostra isso
      return SizedBox(
          height: 200,
          width: 140,
          child: Card(
            elevation: 10,
            child: IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () {
                tirarFoto(n);
              },
            ),
          ));
  }
}
