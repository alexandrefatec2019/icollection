import 'package:cloud_firestore/cloud_firestore.dart';
//import '../VariaveisGlobais/UsuarioGlobal.dart' as g;

class ListaProdutoModel {
  
  String _id; //Codigo do usuario que postou o produto
  int _codigoProduto;
  String _nomeProduto; //Nome do produto anunciado
  String _descricao; //Descrição do produto anunciado
  String _material;
  String _estado;
  String _valor;
  //Ja defini o usuario atravez da variavel global
  DocumentReference _usuario;
  bool _troca;
  List _image;

  ListaProdutoModel(
      this._id,
      this._codigoProduto,
      this._nomeProduto,
      this._descricao,
      this._material,
      this._estado,
      this._valor,
      this._troca,
      this._image,
      this._usuario);

  ListaProdutoModel.map(dynamic obj) {
    this._id = obj['id'];
    this._codigoProduto = obj['codigoproduto'];
    this._nomeProduto = obj['nomeproduto'];
    this._descricao = obj['descricao'];
    this._material = obj['material'];
    this._estado = obj['estado'];
    this._valor = obj['valor'];
    this._troca = obj['troca'];
    this._image = obj['image'];
    this._usuario = obj['usuario'];
  }

  String get id => _id ?? '';
  int get codigoproduto => _codigoProduto ?? null; 
  String get nomeproduto => _nomeProduto ?? '';
  String get descricao => _descricao ?? '';
  String get material => _material ?? ' ';
  String get estado => _estado ?? '';
  String get valor => _valor ?? '';
  bool get troca => _troca ?? '';
  List<String> get image => _image;
  DocumentReference get usuario => _usuario;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['codigoproduto'] = _codigoProduto;
    map['id'] = _id;
    map['nomeproduto'] = _nomeProduto;
    map['descricao'] = _descricao;
    map['material'] = _material;
    map['estado'] = _estado;
    map['valor'] = _valor;
    map['troca'] = _troca;
    map['image'] = _image;
    map['usuario'] = _usuario;

    return map;
  }

  ListaProdutoModel.fromMap(Map<String, dynamic> map) {
    
    this._id = map['id'];
    this._codigoProduto = map['codigoproduto'];
    this._nomeProduto = map['nomeproduto'];
    this._descricao = map['descricao'];
    this._material = map['material'];
    this._estado = map['estado'];
    this._valor = map['valor'];
    this._troca = map['troca'];
    this._image = map['image'];
  }
}
