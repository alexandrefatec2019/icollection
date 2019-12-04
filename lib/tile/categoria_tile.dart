import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icollection/Produto/produto.dart';

import 'package:icollection/categoria.dart';
import 'package:page_transition/page_transition.dart';

class CategoriaTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoriaTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: CachedNetworkImageProvider(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(
          
          PageTransition(type: PageTransitionType.rightToLeft, child: Produto(snapshot))
        );
      },
    );
  }
}