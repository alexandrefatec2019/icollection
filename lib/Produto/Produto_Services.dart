import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import '../VariaveisGlobais/UsuarioGlobal.dart' as g;

//CRUD PRODUTO

final CollectionReference produtoCollection =
    Firestore.instance.collection('ProdutoLista').reference();

class FirebaseFirestoreService {
  static final FirebaseFirestoreService _instance =
      new FirebaseFirestoreService.internal();

  factory FirebaseFirestoreService() => _instance;

  FirebaseFirestoreService.internal();

  Future<ListaProdutoModel> cadastrarProduto(
      String title,
      String description,
      String material,
      String estado,
      String valor,
      bool troca,
      List image) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(produtoCollection.document());

      final ListaProdutoModel produto = ListaProdutoModel(ds.documentID, title,
          description, material, estado, valor, troca, image, null);
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
  //Leitura do produto na lista geral !!!

  Stream<QuerySnapshot> listarTodosProdutos({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = produtoCollection.snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  Stream<QuerySnapshot> xx() {
    Stream<QuerySnapshot> snapshots =
        produtoCollection.where("id", isEqualTo: 'aed').snapshots();
    return snapshots;
  }

  Future<dynamic> updateNote(ListaProdutoModel produto) async {
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

  Future<dynamic> deleteNote(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(produtoCollection.document(id));

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
