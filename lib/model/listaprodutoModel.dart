import 'package:cloud_firestore/cloud_firestore.dart';
//import '../VariaveisGlobais/UsuarioGlobal.dart' as g;

class ListaProdutoModel {
  String _id; //Codigo do usuario que postou o produto
  String _categoria;
  String _nomeProduto; //Nome do produto anunciado
  String _descricao; //Descrição do produto anunciado
  String _material;
  String _estado;
  String _valor;
  //Ja defini o usuario atravez da variavel global
  DocumentReference _usuario;
  bool _troca;
  bool _status;
  Timestamp _criacao;
  Timestamp _modificado;
  int _like;
  String _obs;
  List _image;
  Map rr;

  ListaProdutoModel(
      this._id,
      this._categoria,
      this._nomeProduto,
      this._descricao,
      this._material,
      this._estado,
      this._valor,
      this._troca,
      this._status,
      this._criacao,
      this._modificado,
      this._like,
      this._image,
      this._obs,
      this._usuario);

  ListaProdutoModel.map(dynamic o) {
    this._id = o['id'];
    this._categoria = o['categoria'];
    this._nomeProduto = o['nomeproduto'];
    this._descricao = o['descricao'];
    this._material = o['material'];
    this._estado = o['estado'];
    this._valor = o['valor'];
    this._troca = o['troca'];
    this._status = o['status'];
    this._criacao = o['criacao'];
    this._modificado = o['modificado'];
    this._like = o['like'];
    this._image = o['image'];
    this._obs = o['obs'];
    this._usuario = o['usuario'];
  }

  String get id => _id ?? '';
  String get categoria => _categoria ?? '';
  String get nomeproduto => _nomeProduto ?? '';
  String get descricao => _descricao ?? '';
  String get material => _material ?? ' ';
  String get estado => _estado ?? '';
  String get valor => _valor ?? '';
  bool get troca => _troca ?? '';
  bool get status => _status ?? false;
  Timestamp get criacao => _criacao ?? '';
  Timestamp get modificado => _modificado ?? '';
  int get like => _like ?? 0;
  String get obs => _obs ?? '';
  List<dynamic> get image => _image ?? '';
  DocumentReference get usuario => _usuario;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }

    map['id'] = _id;
    map['categoria'] = _categoria;
    map['nomeproduto'] = _nomeProduto;
    map['descricao'] = _descricao;
    map['material'] = _material;
    map['estado'] = _estado;
    map['valor'] = _valor;
    map['troca'] = _troca;
    map['status'] = _status;
    map['criacao'] = _criacao;
    map['modificado'] = _modificado;
    map['like'] = _like;
    map['image'] = _image ?? '';
    map['usuario'] = _usuario;

    return map;
  }

  ListaProdutoModel.fromMap(Map<String, dynamic> o) {
    this._id = o['id'];
    this._categoria = o['categoria'];
    this._nomeProduto = o['nomeproduto'];
    this._descricao = o['descricao'];
    this._material = o['material'];
    this._estado = o['estado'];
    this._valor = o['valor'];
    this._troca = o['troca'];
    this._status = o['status'];
    this._criacao = o['criacao'];
    this._modificado = o['modificado'];
    this._like = o['like'];
    this._image = o['image'];
    this._obs = o['obs'];
    this._usuario = o['usuario'];
  }
}
