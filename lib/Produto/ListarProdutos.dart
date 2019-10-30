import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:icollection/Principal.dart';

class ListagemGeralProdutos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListaProdutosState();
}

class ListaProdutosState extends State<ListagemGeralProdutos> {

  ScrollController _scrollController;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
  
        child: Center(
      child: Container(
        
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            // DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
            stream: Firestore.instance.collection('Produtos').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading...');
                default:
                  return ListView(
                    physics: new NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return CustomCard(
                        title: document.documentID, // document['icon'],
                        description: document['title'],
                      );
                    }).toList(),
                  );
              }
            },
          )),
    ));
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.title, this.description});

  final title;
  final description;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Text(title),
                FlatButton(
                    child: Text("See More"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Principal(
                                  //title: title, description: description)
                                  )));
                    }),
              ],
            )));
  }
}

