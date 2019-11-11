import 'package:cloud_firestore/cloud_firestore.dart';
//import '../VariaveisGlobais/UsuarioGlobal.dart' as g;

class ListaProdutoModel {
  String _id; //Codigo do usuario que postou o produto
  String _nomeProduto; //Nome do produto anunciado
  String _descricao; //Descrição do produto anunciado
  String _material;
  String _valor;
  //Ja defini o usuario atravez da variavel global
  DocumentReference _usuario;
  bool _troca;
  List _image;

  //DocumentReference _usuario2; //= Firestore.instance.collection('Usuario').document('gruposjrp@gmail.com');
  //Dados do usuario
  String _nomeUsuario;
  String _photoURL;

  ListaProdutoModel(this._id, this._nomeProduto, this._descricao,
      this._material, this._valor, this._troca, this._image,this._usuario);

  ListaProdutoModel.map(dynamic obj) {
    this._id = obj['id'];
    this._nomeProduto = obj['nomeproduto'];
    this._descricao = obj['descricao'];
    this._material = obj['material'];
    this._valor = obj['valor'];
    this._troca = obj['troca'];
    this._image = obj['image'];

    //Referencia
    this._usuario = obj['usuario'];
  }

  String get id => _id;
  String get nomeproduto => _nomeProduto;
  String get descricao => _descricao;
  String get material => _material;
  String get valor => _valor;

  String get nomeUsuario => _nomeUsuario;
  String get imageUsuario => _photoURL;

  //Referencia
  String get usuario => _usuario.path;
  ////////////
  ///
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
    //Referencia
    map['usuario'] = _usuario;

    return map;
  }

  ListaProdutoModel.fromMap(Map<String, dynamic> map) {
    //Recebhe a referencia do usuario
    //Ainda com problemas por isso a tela vermelha na listagem do produto
    DocumentReference _x = map['usuario'];
    _x.get().then((onValue) {
      this._id = map['id'];

      this._nomeProduto = map['nomeproduto'];
      this._descricao = map['descricao'];
      this._material = map['material'];
      this._valor = map['valor'];
      this._troca = map['troca'];
      this._image = map['image'];

      this._nomeUsuario = onValue.data['nome'];
      this._photoURL = onValue.data['photourl'];

      print('\n\n refer = ' + _nomeUsuario);
    });
  }
}
