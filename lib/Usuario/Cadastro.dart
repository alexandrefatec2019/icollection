import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:icollection/Principal.dart';
import 'package:icollection/Usuario/UsuarioService.dart';
import 'package:icollection/model/usuarioModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CadDados extends StatefulWidget {
  final UsuarioModel user;
  CadDados(this.user);

  @override
  State<StatefulWidget> createState() => CadDadosState();
}

class CadDadosState extends State<CadDados> {
  final formKey = GlobalKey<FormState>();

  FirebaseFirestoreService db = new FirebaseFirestoreService();

  //TODO verificar depois se é possivel diminuir o numero de vars
  String uid;
  String nome;
  String email;
  String cpfcnpj;
  String telefone;
  String photoUrl;

  File imagem;
  bool uploading = false;

  TextEditingController _nome;
  TextEditingController _email;
  TextEditingController _cpfcnpj;
  TextEditingController _telefone;
  TextEditingController _photourl;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    uid = widget.user.id;
    _nome = new TextEditingController(text: widget.user.nome);
    _email = new TextEditingController(text: widget.user.email);
    _cpfcnpj = new TextEditingController(text: widget.user.cpfcnpj);
    _telefone = new TextEditingController(text: widget.user?.telefone);
    photoUrl = (widget.user.photourl);
  }

  //Exatamente = do professor passou em sala
  //Retornando a url da photo postada
  Future<String> tirarFoto() async {
    var _imagem = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 10, maxHeight: 800, maxWidth: 600);

    var usuario = (widget.user.email);

    setState(() {
      this.imagem = _imagem;
      this.uploading = true;
    });

    //Salva a foto do perfil na pasta do usuario
    var ref = FirebaseStorage().ref().child('/Usuario/$usuario/photo_perfil');

    StorageUploadTask upload = ref.putFile(_imagem);

    var downloadUrl = await upload.onComplete;

    var url = await downloadUrl.ref.getDownloadURL();

    setState(() {
      //Alterar variavel photoUrl com a nova url
      photoUrl = url.toString();
      this.uploading = false;
    });

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Dados do Usuário'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Color(0xff1c2634),
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            // Container(

            child: Center(
                child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: tirarFoto,
                  child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          //link da imagem, ao login pegar do Google ou Facebook
                          //ao alterar !! hunmnnn....
                          image: NetworkImage(photoUrl)

                          //NetworkImage(widget.user.photourl),
                          ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 18,
                    ),
                    child: Text(
                      'Confirme seus dados:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                //Form
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 50,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  //Nome
                  child: TextFormField(
                    onSaved: (value) {
                      setState(() {
                        nome = value;
                      });
                    },
                    validator: (val) =>
                        val.isEmpty ? 'Nome não pode ser vasio.' : null,
                    keyboardType: TextInputType.text,
                    controller: _nome,
                    decoration: InputDecoration(
                        labelText: 'Nome *', icon: Icon(Icons.person)),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 50,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  //Email
                  child: TextFormField(
                    onSaved: (value) => email = value,
                    controller: _email,
                    validator: (val) =>
                        !val.contains('@') ? 'Endereço invalido.' : null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'E-mail *',
                        hintText: 'email@exemplo.com',
                        icon: Icon(Icons.email)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 50,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  //CPF/CNPJ
                  child: TextFormField(
                    onSaved: (value) => cpfcnpj = value,
                    controller: _cpfcnpj,
                    decoration: InputDecoration(
                        labelText: 'CPF/CNPJ *', icon: Icon(Icons.dehaze)),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 50,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  //CPF/CNPJ
                  child: TextFormField(
                    onSaved: (value) => telefone = value,
                    controller: _telefone,
                    decoration: InputDecoration(
                        labelText: 'Telefone *', icon: Icon(Icons.phone)),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 32),
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: 50,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50)),
                    color: Color(0xff1f631b),
                    onPressed: () {
                      //TESTE
                      //tirarFoto();

                      //validação
                      db
                          .criarUsuario(uid, _nome.text, _email.text,
                              _cpfcnpj.text, _telefone.text, photoUrl)
                          .whenComplete(() {
                        //print(value);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Principal()));
                      });
                    },
                    child: Center(
                      child: Text(
                        'CONFIRMAR'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ));
  }
}
