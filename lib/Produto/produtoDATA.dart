import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:icollection/model/usuarioModel.dart';
import 'package:icollection/Usuario/UsuarioDATA.dart';

//CRUD USUARIO

final CollectionReference produtoCollection =
    Firestore.instance.collection('ProdutoLista');

class FirebaseFirestoreService {
  static final FirebaseFirestoreService _instance =
      new FirebaseFirestoreService.internal();

  factory FirebaseFirestoreService() => _instance;

  FirebaseFirestoreService.internal();

// Ler dados do usuario logado
Future<UsuarioModel> lerUsuario(String email) async {
    var document = usuarioCollection.document(email).get();
    return await document.then((doc) {
      return UsuarioModel.map(doc);
    });
  }


  //TODO passar o model em vez de variaveis

  Future<ListaProdutoModel> criarProduto(String id, String nomeProduto, String descricao,
      String material, String valor, bool troca, List image) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      //Salva um documento na Coleção usuario com o nome id do google (uid)
      final DocumentSnapshot ds = await tx.get(produtoCollection.document(id));

      final ListaProdutoModel produto =
          ListaProdutoModel(id, nomeProduto, descricao, material, valor, troca, image);
      final Map<String, dynamic> data = produto.toMap();

      await tx.set(ds.reference, data);

      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return ListaProdutoModel.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Future<dynamic> updateProduto(ListaProdutoModel produto) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(produtoCollection.document(produto.id));

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
