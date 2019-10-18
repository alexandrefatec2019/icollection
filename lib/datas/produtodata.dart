import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutoData {
  String categoria;
  String id;
  String nome;
  String descricao;
  bool disponibilidade;
  bool troca;
  String valor;
  List imagens;

  ProdutoData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    nome = snapshot.data['nome'];
    descricao = snapshot.data['descricao'];
    disponibilidade = snapshot.data['disponibilidade'];
    troca = snapshot.data['troca'];
    valor = snapshot.data['valor'];
    imagens = snapshot.data['imagens'];
    
  }
}