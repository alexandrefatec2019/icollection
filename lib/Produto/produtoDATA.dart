import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icollection/model/listaprodutoModel.dart';
import 'package:icollection/Usuario/UsuarioDATA.dart';

//CRUD PRODUTO

final CollectionReference produtoCollection =
    Firestore.instance.collection('ProdutoLista');

class FirebaseFirestoreService {
  static final FirebaseFirestoreService _instance =
      new FirebaseFirestoreService.internal();

  factory FirebaseFirestoreService() => _instance;

  FirebaseFirestoreService.internal();

// Ler dados do produto
  Future<ListaProdutoModel> lerProduto(String nomeproduto) async {
    var document = produtoCollection.document(nomeproduto).get();
    return await document.then((doc) {
      return ListaProdutoModel.map(doc);
    });
  }

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
  //TODO passar o model em vez de variaveis !!!!!!!!!!!!!!!

  Future<bool> criarProduto(ListaProdutoModel l) async {
    try {
      final TransactionHandler createTransaction = (Transaction tx) async {
        //Salva um documento na Coleção usuario com o nome id do google (uid)
        final DocumentSnapshot ds = await tx.get(produtoCollection.document());
        final ListaProdutoModel produto = ListaProdutoModel(
            ds.documentID,
            l.nomeproduto,
            l.descricao,
            l.material,
            l.estado,
            l.valor,
            l.troca,
            l.status,
            l.criacao,
            l.modificado,
            l.like,
            l.image,
            l.obs,
            l.usuario);

        final Map<String, dynamic> data = produto.toMap();

        await tx.set(ds.reference, data);
      };
      Firestore.instance.runTransaction(createTransaction);

      return true;
    } catch (e) {
      return false;
    }
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
