class ListaProdutoModel {
  String _id; //Codigo do usuario que postou o produto
  String _nomeProduto; //Nome do produto anunciado
  String _descricao; //Descrição do produto anunciado
  String _material;
  String _valor;
  bool _troca;
  List _image; //talvez uma lista com mais de uma imagem

  ListaProdutoModel(this._id, this._nomeProduto, this._descricao, this._image);

  ListaProdutoModel.map(dynamic obj) {
    this._id = obj['id'];
    this._nomeProduto = obj['nomeproduto'];
    this._descricao = obj['descricao'];
    this._material = obj['material'];
    this._valor = obj['valor'];
    this._troca = obj['troca'];
    this._image = obj['image'];
  }

  String get id => _id;
  String get nomeproduto => _nomeProduto;
  String get descricao => _descricao;
  String get material => _material;
  String get valor => _valor;
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

    return map;
  }

  ListaProdutoModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nomeProduto = map['nomeproduto'];
    this._descricao = map['descricao'];
    this._material = map['material'];
    this._valor = map['valor'];
    this._troca = map['troca'];
    this._image = map['image'];
  }
}