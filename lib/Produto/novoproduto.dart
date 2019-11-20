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

class NovoProduto extends StatefulWidget {
  final ListaProdutoModel product;
  NovoProduto(this.product);

  @override
  _NovoProdutoState createState() => _NovoProdutoState();
}

class _NovoProdutoState extends State<NovoProduto> {
  prefix0.FirebaseFirestoreService db = new prefix0.FirebaseFirestoreService();
  var usuario = g.email;
  final _formKey = GlobalKey<FormState>();
  DocumentSnapshot snapshot;

  //TODO - Pagina NovoProduto - Pegar info do Model ou Data do Produto
  String uid;
  String nomeProduto;
  String descricao;
  String valor;
  String material;
  String _estado;
  bool troca = false;
  int _estadoSelecionado = null; // ainda não inserido
  String _categoriaSelecionada;

  List<DropdownMenuItem<int>> estadoList = [];
  // List<DropdownMenuItem<int>> categoriaList = [];
  List<String> img = [
    // 'https://cdn.shopify.com/s/files/1/0973/0376/products/mail_b48a54fc-2368-4e05-ae2d-fe8a4f4dcb39.jpg?v=1548118355'
  ];
  //teste
  String urlphoto;

  TextEditingController _nomeProduto;
  TextEditingController _descricao;
  TextEditingController _valor;
  TextEditingController _material;
  TextEditingController _troca;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();

    _nomeProduto = new TextEditingController(text: widget.product?.nomeproduto);
    _descricao = new TextEditingController(text: widget.product?.descricao);
    _valor = new TextEditingController(text: widget.product?.valor);
    _material = new TextEditingController(text: widget.product?.material);
  }
//     if (widget.product.id == null) {
//       _nomeProduto = new TextEditingController(text: widget.product.nomeproduto);
//       _descricao = new TextEditingController(text: widget.product.descricao);
//       _valor = new TextEditingController(text: widget.product.valor);
//       _material = new TextEditingController(text: widget.product.material);
//     }
// }

  
  Map<int, File> imagens = Map();
  
  //File imagem;
  File imagem1;
  File imagem2;
  File imagem3;
  File imagem4;
  File imagem5;
  File imagem6;

  bool uploading = false;

  void _categorySelected(String newValueSelected) {
    setState(() {
      this._categoriaSelecionada = newValueSelected;
    });
  }

  void loadEstadoList() {
    estadoList = [];
    estadoList.add(new DropdownMenuItem(
      child: new Text('Novo'),
      value: 0,
    ));
    estadoList.add(new DropdownMenuItem(
      child: new Text('Usado'),
      value: 1,
    ));
    estadoList.add(new DropdownMenuItem(
      child: new Text('Seminovo'),
      value: 2,
    ));
    estadoList.add(new DropdownMenuItem(
      child: new Text('Restaurado'),
      value: 3,
    ));
  }

  // @override
  // void initState() {
  //   SystemChrome.setEnabledSystemUIOverlays([]);
  //   super.initState();

  // }
  @override
  Widget build(BuildContext context) {
    loadEstadoList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1c2634),
        title: Text('Novo Anúncio'),
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

  
  
  void tirarFoto(int n) async {
    var _imagem = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      //Add o arquivo na lista
      imagens.putIfAbsent(n, () => _imagem);
      //this.uploading = true;
    });

    var endereco = '/Produtos/'+usuario+'/'+_imagem.hashCode.toString()+'.jpg';

    var ref = FirebaseStorage().ref().child(endereco);
    
    StorageUploadTask upload = ref.putFile(_imagem);
    var downloadUrl = await upload.onComplete;
    String url = (await downloadUrl.ref.getDownloadURL());
    
    if(url != null)
    img.add(url);
    print('imag da lista = '+img.map((f){print(f);}).toString());
  }
  
  
// ------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------
//   Future saveImage() async {
//   final StorageReference ref = FirebaseStorage().ref().child('/Produtos/$usuario/imagem1');
//   StorageUploadTask upload = ref.putFile(imagem1);
//   var downloadUrl = await upload.onComplete;
//   var url = await downloadUrl.ref.getDownloadURL();
// }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    //---------- CATEGORIA ----------
    // formWidget.add(new StreamBuilder<QuerySnapshot>(
    //   stream: Firestore.instance.collection('Produtos').snapshots(),
    //   builder: (context, snapshot){
    //     return Container(
    //       child: Row(
    //         children: <Widget>[
    //           Expanded(
    //             child: DropdownButton(
    //               hint: new Text('Escolha a Categoria:'),
    //               items: snapshot.data.documents.map((DocumentSnapshot document){
    //                 return DropdownMenuItem<String>(
    //                   value: document.data['title'],
    //                   child: Text(document.data['title']),
    //                 );
    //               },
    //               ).toList(),
    //               // value: _categoriaSelecionada,
    //               onChanged: (valorSelecionado) {
    //                 _categorySelected(valorSelecionado);
    //               },
    //               isExpanded: true,
    //             ),
    //           )
    //         ],
    //       ),
    //     );
    //   },
    // )
    // );

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
      keyboardType: TextInputType.text,
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
    formWidget.add(new DropdownButton(
      hint: new Text('Estado do Produto:'),
      items: estadoList,
      value: _estadoSelecionado,
      onChanged: (value) {
        setState(() {
          if (value == 0) {
            _estado = 'Novo';
          } else if (value == 1) {
            _estado = 'Usado';
          } else if (value == 2) {
            _estado = 'Seminovo';
          } else if (value == 3) {
            _estado = 'Restaurado';
          }
          _estadoSelecionado = value;
        });
      },
      isExpanded: true,
    ));

    //---------- VALOR R$ ----------
    formWidget.add(new TextFormField(
      keyboardType: TextInputType.text,
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
              Card(
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2.7,
                    color: Colors.grey[200],
                    child: this.imagens.containsKey(1) == false 
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              tirarFoto(1);
                            },
                          )
                        : Image.file(imagens[1]),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2.7,
                    color: Colors.grey[200],
                    child: this.imagens.containsKey(2) == false
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              tirarFoto(2);
                            },
                          )
                        : Image.file(imagens[2]),
                  ),
                ),
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2.7,
                    color: Colors.grey[200],
                    child: this.imagens.containsKey(3) == false
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              tirarFoto(3);
                            },
                          )
                        : Image.file(this.imagens[3]),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2.7,
                    color: Colors.grey[200],
                    child: this.imagens.containsKey(4) == false
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              tirarFoto(4);
                            },
                          )
                        : Image.file(this.imagens[4]),
                  ),
                ),
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2.7,
                    color: Colors.grey[200],
                    child: this.imagens.containsKey(5) == false
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              tirarFoto(5);
                            },
                          )
                        : Image.file(imagens[5]),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2.7,
                    color: Colors.grey[200],
                    child: this.imagens.containsKey(6) == false
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              tirarFoto(6);
                            },
                          )
                        : Image.file(this.imagens[6]),
                  ),
                ),
              ),
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
          db.criarProduto(ListaProdutoModel(
              uid,
              _nomeProduto.text,
              _descricao.text,
              _material.text,
              _estado,
              _valor.text,
              troca,
              img,
              g.usuarioReferencia));
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
}
