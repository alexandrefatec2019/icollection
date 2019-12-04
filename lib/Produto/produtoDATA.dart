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

//remove imagem do produto (lista)
  Future<bool> removeImagem(String produtoId, String url) {
    final TransactionHandler removeImageTrans = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(produtoCollection.document(produtoId));

      List<String> imgproduto = [url]; //userId
      await tx.update(ds.reference, {
        'image': FieldValue.arrayRemove(imgproduto),
      });
    };

    return Firestore.instance
        .runTransaction(removeImageTrans)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  Future<bool> criarProduto(ListaProdutoModel l) async {
    try {
      final TransactionHandler createTransaction = (Transaction tx) async {
        //Salva um documento na Coleção usuario com o nome id do google (uid)
        final DocumentSnapshot ds = await tx.get(produtoCollection.document());
        final ListaProdutoModel produto = ListaProdutoModel(
            ds.documentID,
            l.categoria,
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

  Future<bool> updateProduto(ListaProdutoModel produto) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(produtoCollection.document(produto.id));

      await tx.update(ds.reference, {
        'categoria' : produto.categoria,
        'estado': produto.estado,
        'image': produto.image,
        'material': produto.material,
        'modificado': Timestamp.now(),
        'status': produto.status,
        'troca': produto.troca,
        'valor': produto.valor,
        'nomeproduto': produto.nomeproduto,
        'descricao': produto.descricao
      });
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
