import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:icollection/Login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Classe autenticação
Autentica auth = Autentica();
String _email;
String _imagemURL;
String _nomeUsuario;
String _telefone;

class DadosUser extends StatefulWidget{
  final _email;
  final _imagemURL;
  final _nomeUsuario;
  final _telefone;

DadosUser(this._email, this._imagemURL, this._nomeUsuario, this._telefone);


  @override
  State<StatefulWidget> createState() => DadosUserState();
}
class DadosUserState extends State<DadosUser>{
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
                title: Text('Dados do Usuário'), centerTitle: true,
                leading: IconButton(icon:Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: Color(0xff1c2634),
              ),
      ),
      body: SingleChildScrollView(
      // Container(
        child: Center(
          child: Column( 
          children: <Widget>[
              
            Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(_imagemURL),
                ),
              ),
            ),
            Align(
                  alignment: Alignment.center,
                  child: Padding(
                  padding: const EdgeInsets.only( top:18,),
                  child: Text('Confirme seus dados:', style: TextStyle(fontSize: 16,),),

                  ),
            ),

            //Form
            Container(
              width: MediaQuery.of(context).size.width/1.1,
                            height: 50,
                            padding: EdgeInsets.only(
                              top: 4, left: 16, right: 16, bottom: 4
                            ),
            //Nome
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nome *',
                        hintText: _nomeUsuario,
                        icon: Icon(Icons.person)
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width/1.1,
                            height: 50,
                            padding: EdgeInsets.only(
                              top: 4, left: 16, right: 16, bottom: 4
                            ),
                    //Email
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail *',
                        hintText: _email,
                        icon: Icon(Icons.email)
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width/1.1,
                            height: 50,
                            padding: EdgeInsets.only(
                              top: 4, left: 16, right: 16, bottom: 4
                            ),
                    //CPF/CNPJ
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'CPF/CNPJ *',

                        icon: Icon(Icons.dehaze)
                      ),
                    ),
            ),
            
            Container(
              width: MediaQuery.of(context).size.width/1.1,
                            height: 50,
                            padding: EdgeInsets.only(
                              top: 4, left: 16, right: 16, bottom: 4
                            ),
                    //CPF/CNPJ
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Telefone *',
                        hintText: _telefone,
                        icon: Icon(Icons.phone)
                      ),
                    ),
            ),

            Container(
                            margin: EdgeInsets.only(top: 16, bottom: 32),
                            width: MediaQuery.of(context).size.width/1.3,
                            height: 50,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50)),
                              color: Color(0xff1f631b),
                              onPressed: (){
                                //validação
                              },
                              child: Center(
                                child: Text('CONFIRMAR'.toUpperCase(),
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
        ),
      )
      );
      
  }
}