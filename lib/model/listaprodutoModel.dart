class ListaProdutoModel {
  String _id; //Codigo do usuario que postou o produto
  String _nomeProduto; //Nome do produto anunciado
  String _descricao; //Descrição do produto anunciado

  ListaProdutoModel(this._id, this._nomeProduto, this._descricao);

  ListaProdutoModel.map(dynamic obj) {
    this._id = obj['id'];
    this._nomeProduto = obj['nomeproduto'];
    this._descricao = obj['descricao'];
  }

  String get id => _id;
  String get nomeproduto => _nomeProduto;
  String get descricao => _descricao;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['nomeproduto'] = _nomeProduto;
    map['descricao'] = _descricao;

    return map;
  }

  ListaProdutoModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nomeProduto = map['nomeproduto'];
    this._descricao = map['descricao'];
  }
}
