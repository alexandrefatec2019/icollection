import 'package:flutter/material.dart';

class Vendas extends StatefulWidget {
  @override
  _VendasState createState() => _VendasState();
}

class _VendasState extends State<Vendas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO - Botão Novo anuncio
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){

        },
        icon: Icon(Icons.add),
        label: Text('Novo Anúncio'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}