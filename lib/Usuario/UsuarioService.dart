import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:icollection/model/usuarioModel.dart';

//CRUD USUARIO



final CollectionReference usuarioCollection =
    Firestore.instance.collection('Usuario');

class FirebaseFirestoreService {
  static final FirebaseFirestoreService _instance =
      new FirebaseFirestoreService.internal();

  factory FirebaseFirestoreService() => _instance;

  FirebaseFirestoreService.internal();

  Future<UsuarioModel> criarUsuario(String nome, String sobrenome, String email, String cpfcnpj, String telefone) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(usuarioCollection.document());

      final UsuarioModel usuario =
          UsuarioModel(ds.documentID, nome, sobrenome, email, cpfcnpj, telefone);
      final Map<String, dynamic> data = usuario.toMap();

      await tx.set(ds.reference, data);
      print('xxxxxxxxxxxxxxxxxxxxxxxxx');
      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return UsuarioModel.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Future<dynamic> updateUsuario(ListaProdutoModel produto) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(usuarioCollection.document(produto.id));

      await tx.update(ds.reference, produto.toMap());
      return {'updated': true};
    };

    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  //SEM USO
  Future<dynamic> deleteUsuario(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(usuarioCollection.document(id));

      await tx.delete(ds.reference);
      return {'deleted': true};
    };

    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }
}
