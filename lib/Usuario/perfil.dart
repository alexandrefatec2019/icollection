import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:icollection/Login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icollection/Principal.dart';
import 'package:icollection/Usuario/dadosuser.dart';
import 'package:icollection/Usuario/historico.dart';


//Classe autenticação
Autentica auth = Autentica();
String _email;
String _imagemURL;
String _nomeUsuario;
String _telefone;

class Perfil extends StatefulWidget{
  final _email;
  final _imagemURL;
  final _nomeUsuario;
  final _telefone;

  Perfil(this._email, this._imagemURL, this._nomeUsuario, this._telefone);

  @override
  State<StatefulWidget> createState() => PerfilState();
}
class PerfilState extends State<Perfil>{
  @override void initState() {
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
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child:AppBar( 
                automaticallyImplyLeading: true,
                title: Text('Perfil do Usuário'), centerTitle: true,
                leading: IconButton(icon:Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: Color(0xff1c2634),
              ),
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
              width: MediaQuery.of(context).size.width/1,
              top: MediaQuery.of(context).size.height/6,
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
                        fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(75.0)
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7.0,
                          color: Color(0xff1c2634),
                          )
                      ]
                    ),
                  ),
                  //Nome Principal
                  SizedBox(
                    height: 90.0,
                  ),
                  Text(_nomeUsuario, style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  ),

                  //Botoes
                  ButtonTheme.bar(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                            margin: EdgeInsets.only(top: 8),
                            width: 90,
                            height: 30,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50)),
                              color: Color(0xff1c2634),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                builder: (context) => DadosUser(_email, _imagemURL, _nomeUsuario, _telefone)));

                              },
                              child: Center(
                                child: Text('Dados',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 8),
                            width: 90,
                            height: 30,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50)),
                              color: Color(0xff1c2634),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Historico()));
                              },
                              child: Center(
                                child: Text('Histórico',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            width: 90,
                            height: 30,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50)),
                              color: Colors.red,
                              onPressed: (){
                                auth.googleLogout;
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Principal()));
                              },
                              child: Center(
                                child: Text('Sair',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                ],
              )
            )
                ],
                
              ),
            ),

          ],
      )
    );
  }
}
class getClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(0.0, size.height/2);
    path.lineTo(size.width+200, 0.0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}