import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/Produto_Services.dart';
import 'package:icollection/model/usuarioModel.dart';

class ListaProdutoModel {
  String _id; //Codigo do usuario que postou o produto
  String _nomeProduto; //Nome do produto anunciado
  String _descricao; //Descrição do produto anunciado
  String _material;
  String _valor;
  bool _troca;
  List _image;

  //DocumentReference _usuario2; //= Firestore.instance.collection('Usuario').document('gruposjrp@gmail.com');
  //Dados do usuario
  String _nomeUsuario;
  String _photoURL;

  ListaProdutoModel(this._id, this._nomeProduto, this._descricao,
      this._material, this._valor, this._troca, this._image);

  ListaProdutoModel.map(dynamic obj) {
    this._id = obj['id'];
    this._nomeProduto = obj['nomeproduto'];
    this._descricao = obj['descricao'];
    this._material = obj['material'];
    this._valor = obj['valor'];
    this._troca = obj['troca'];
    this._image = obj['image'];
    //this._teste = obj['usuario'];
  }

  String get id => _id;
  String get nomeproduto => _nomeProduto;
  String get descricao => _descricao;
  String get material => _material;
  String get valor => _valor;

  String get nomeUsuario => _nomeUsuario;
  String get imageUsuario => _photoURL;

  // String get produtoUsuario {
  //   _teste.get().then((onValue) {
  //    //print(onValue.data['nome']);
  //   _nomeB = onValue.data['nome'].toString();
  //    });
  //   print(_nomeB);
  //   return _nomeB;
  // }

  //Referencia

// Future<Map<String, dynamic>> read() {
//   var _x   = _teste.get().then((onValue) {
//     //print(onValue.data['nome']);
//     return (onValue.data);
//     }
//     ).toString();
//     print(_x);
//     return _x;

// }

//   snapshots().listen((data) {
//   data.documents.forEach((document) {
//       print(document.data['FKOne'].path);
//       document.data['FKTwo'].forEach((documentReference) => print(documentReference.path));
//   });
// });

  bool get troca => _troca;
  List get image => _image;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['nomeproduto'] = _nomeProduto;
    map['descricao'] = _descricao;
    map['material'] = _material;
    map['valor'] = _valor;
    map['troca'] = _troca;
    map['image'] = _image;
    map['usuario'] = _nomeUsuario;
    return map;
  }

  ListaProdutoModel.fromMap(Map<String, dynamic> map) {
    //Recebhe a referencia do usuario
    DocumentReference _x = map['usuario'];
    _x.get().then((onValue) {
      this._id = map['id'];
      this._nomeProduto = map['nomeproduto'];
      this._descricao = map['descricao'];
      this._material = map['material'];
      this._valor = map['valor'];
      this._troca = map['troca'];
      this._image = map['image'];

      this._nomeUsuario = onValue.data['nome'].toString();
      this._photoURL = onValue.data['photourl'].toString();

      print('\n\n refer = ' + _nomeUsuario);
    });
  }
}
