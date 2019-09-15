import 'package:flutter/material.dart';
import 'package:icollection/Principal.dart';


void main() => runApp(Icollection());

class Icollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Rotas do App
    var routes = {
      //Menu Principal - AppBar, Body
      '/': (context) => Principal()
      //      '/detalhe': (context) => Detalhe()
    };

    var materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: '/',
    );

    return materialApp;
  }
}
