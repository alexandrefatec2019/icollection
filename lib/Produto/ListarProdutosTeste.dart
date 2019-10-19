import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icollection/Produto/Produto_Services.dart';
import 'package:icollection/Produto/note_screen.dart';
import 'package:icollection/model/listaprodutoModel.dart';


//Futuramente será formatado, mas ja traz a lista dos produtos do firabase e a rolagem funciona



class ListViewNote extends StatefulWidget {
  @override
  _ListViewNoteState createState() => new _ListViewNoteState();
}

class _ListViewNoteState extends State<ListViewNote> {
  List<ListaProdutoModel> items;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> noteSub;

  @override
  void initState() {
    super.initState();

    items = new List();

    noteSub?.cancel();
    noteSub = db.getNoteList().listen((QuerySnapshot snapshot) {
      final List<ListaProdutoModel> notes = snapshot.documents
          .map((documentSnapshot) =>
              ListaProdutoModel.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = notes;
      });
    });
  }

  @override
  void dispose() {
    noteSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.all(5.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${items[position].nomeproduto}',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  subtitle: Text(
                    '${items[position].descricao}',
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  leading: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(1.0)),
                      // IconButton(
                      //     icon: const Icon(Icons.remove_circle_outline),
                      //     onPressed: () =>
                      //         _deleteNote(context, items[position], position)),
                    ],
                  ),
                  onTap: () => _navigateToNote(context, items[position]),
                ),
              ],
            );
          }),
    );
    // floatingActionButton: FloatingActionButton(
    //   child: Icon(Icons.add),
    //   onPressed: () => _createNewNote(context),
    // ),
  }


  void _navigateToNote(BuildContext context, ListaProdutoModel note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note)),
    );
  }

  void createNewNote(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NoteScreen(ListaProdutoModel(null, '', ''))),
    );
  }
}
