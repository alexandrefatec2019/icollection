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

  //Leitura de dados do usuario
  Future<UsuarioModel> lerUsuario(String email) async {
    final TransactionHandler leituraTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =await tx.get(usuarioCollection.document(email));

      //await tx.update(ds.reference, usuario.toMap());
      
      //return ds.data['email'].to;
    };
     return Firestore.instance.runTransaction(leituraTransaction).then((mapData) {
      return UsuarioModel.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });

    
  }
  Future<UsuarioModel> criarUsuario(String uid, String nome, String email,
      String cpfcnpj, String telefone, String photourl) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      //Salva um documento na Coleção usuario com o nome id do google (uid)
      final DocumentSnapshot ds = await tx.get(usuarioCollection.document(uid));

      final UsuarioModel usuario =
          UsuarioModel(uid, nome, email, cpfcnpj, telefone, photourl);
      final Map<String, dynamic> data = usuario.toMap();

      await tx.set(ds.reference, data);

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
