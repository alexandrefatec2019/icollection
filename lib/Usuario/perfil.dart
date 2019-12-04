import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:icollection/Login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icollection/Principal.dart';
import 'package:icollection/Usuario/Cadastro.dart';
import 'package:icollection/model/usuarioModel.dart';
import 'package:page_transition/page_transition.dart';

//Classe autenticação
Autentica auth = Autentica();
String _email;
String _imagemURL;
String _nomeUsuario;
String _telefone;

class Perfil extends StatefulWidget {
  final _email;
  final _imagemURL;
  final _nomeUsuario;
  final _telefone;

  Perfil(this._email, this._imagemURL, this._nomeUsuario, this._telefone);

  @override
  State<StatefulWidget> createState() => PerfilState();
}

class PerfilState extends State<Perfil> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    _atualizaDados();
  }

  _atualizaDados() {
    setState(() {
      _email = widget._email;
      _imagemURL = widget._imagemURL;
      _nomeUsuario = widget._nomeUsuario;
      _telefone = widget._telefone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Perfil do Usuário'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Color(0xff1c2634),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                    context,
                    PageTransition(type: PageTransitionType.rightToLeft, child: CadDados(true)));
          },
          backgroundColor: Colors.green[400],
          label: Text('EDITAR DADOS'),
          icon: Icon(Icons.edit),
        ),
        body:
            // Container(
            Stack(
          children: <Widget>[
            //  -- BARRA VERTICAL - class --
            ClipPath(
              child: Container(
                color: Color(0xff1c2634),
              ),
              clipper: getClipper(),
            ),
            //  -- --
            Positioned(
              width: MediaQuery.of(context).size.width / 1,
              top: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            //Imagem da Rede Social
                            image: new NetworkImage(_imagemURL),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7.0,
                            color: Color(0xff1c2634),
                          )
                        ]),
                  ),
                  SizedBox(height: 70,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //Lista
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nome:", style: TextStyle(fontSize: 14),),
                        SizedBox(height: 2,),
                        Text (_nomeUsuario, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),

                        Text("Email:", style: TextStyle(fontSize: 14),),
                        SizedBox(height: 2,),
                        Text (_email, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),

                        Text("Telefone:", style: TextStyle(fontSize: 14),),
                        SizedBox(height: 2,),
                        Text (_telefone??'', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),
                      ],
                    ),
                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width + 200, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
