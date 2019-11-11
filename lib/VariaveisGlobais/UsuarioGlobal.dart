library my_prj.globals;

import 'package:cloud_firestore/cloud_firestore.dart';

String id; //Codigo do usuario

//Dados do database
String nome; //Nome
String email; //email vindo do database
String cpfcnpj; //CPU ou CNPJ
String telefone; //Telefone
String photourl; //Endereço da foto

//só se altera pelo main
bool dadosUser = false; //Verifica se existe o cadastro no database

DocumentReference usuarioReferencia;

//vem da autenticação
String nomeAuth;
String emailAuth;
String photoAuth;

 //String get id => id2 ?? '0';
  