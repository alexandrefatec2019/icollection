
//Modelo do usuario com os campos que estao na tela

class UsuarioModel {
  String _id; //Codigo do usuario
  String _nome; //Nome
  String _sobrenome; //Sobrenome
  String _email; //Descrição do produto anunciado
  String _cpfcnpj; //CPU ou CNPJ
  String _telefone; //Telefone

  UsuarioModel(
      this._id, this._nome, this._sobrenome, this._email, this._cpfcnpj, this._telefone);

  UsuarioModel.map(dynamic obj) {
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._sobrenome = obj['sobrenome'];
    this._email = obj['email'];
    this._cpfcnpj = obj['cpfcnpj'];
    this._telefone = obj['telefone'];
  }

  String get id => _id;
  String get nome => _nome;
  String get sobrenome => _sobrenome;
  String get email => _email;
  String get cpfcnpj => _cpfcnpj;
  String get telefone => _telefone;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['nome'] = _nome;
    map['sobrenome'] = _sobrenome;
    map['email'] = _email;
    map['cpfcnpj'] = _cpfcnpj;
    map['telefone'] = _telefone;

    return map;
  }

  UsuarioModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nome = map['nome'];
    this._sobrenome = map['sobrenome'];
    this._email = map['email'];
    this._cpfcnpj = map['cpfcnpj'];
    this._telefone = map['telefone'];
  }
}
