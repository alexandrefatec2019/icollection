import 'package:flutter/material.dart';
import 'package:icollection/Produto/Produto_Services.dart';
import 'package:icollection/model/listaprodutoModel.dart';

class NoteScreen extends StatefulWidget {
  final ListaProdutoModel note;
  NoteScreen(this.note);

  @override
  State<StatefulWidget> createState() => new _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  TextEditingController _titleController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = new TextEditingController(text: widget.note.nomeproduto);
    _descriptionController =
        new TextEditingController(text: widget.note.descricao);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          Padding(padding: new EdgeInsets.all(5.0)),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          Padding(padding: new EdgeInsets.all(5.0)),
          RaisedButton(
            child: (widget.note.id != null) ? Text('Update') : Text('Add'),
            onPressed: () {
              if (widget.note.id != null) {
                db
                    .updateNote(ListaProdutoModel(widget.note.id,
                        _titleController.text, _descriptionController.text,null))
                    .then((_) {
                  Navigator.pop(context);
                });
              } else {
                db
                    .createNote(
                        _titleController.text, _descriptionController.text,null)
                    .then((_) {
                  Navigator.pop(context);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
