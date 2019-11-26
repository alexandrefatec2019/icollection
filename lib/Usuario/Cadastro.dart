import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:icollection/Principal.dart';
import 'package:icollection/Produto/ListarProdutosPrincipal.dart';
import 'package:icollection/Usuario/UsuarioDATA.dart';
import 'package:icollection/Usuario/dadosuser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

//cuida da sobreposição do teclado
import 'ensure.dart';

import 'package:icollection/VariaveisGlobais/UsuarioGlobal.dart' as g;
import 'package:cached_network_image/cached_network_image.dart';

class CadDados extends StatefulWidget {
  final bool authUser;
  CadDados(this.authUser);
  @override
  _CadDadosState createState() => new _CadDadosState();
}

class _CadDadosState extends State<CadDados> {
  FirebaseFirestoreService db = new FirebaseFirestoreService();
  //TODO verificar depois se é possivel diminuir o numero de vars
  String uid;
  String nome;
  String email;
  String cpfcnpj;
  String telefone;
  String _photoUrl = '';

  File imagem;
  bool uploading = false;

  TextEditingController _nome;
  TextEditingController _email;
  TextEditingController _cpfcnpj;
  TextEditingController _telefone;
  //TextEditingController _photourl;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  FocusNode _focusNome = new FocusNode();
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusCPFCNPJ = new FocusNode();
  FocusNode _focusTelefone = new FocusNode();

  // static final TextEditingController _nomeController =
  //     new TextEditingController();
  // static final TextEditingController _emailController =
  //     new TextEditingController();
  // static final TextEditingController _telefoneController =
  //     new TextEditingController();

  //Exatamente = do professor passou em sala
  //Retornando a url da photo postada
  Future<String> tirarFoto() async {
    var _imagem = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 96,
        maxWidth: 96);

    //TODO ver se vem do auth ou do db
    var usuario = g.emailAuth;

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
      _photoUrl = url.toString();
      this.uploading = false;
    });
    print(url.toString());

    return url;
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    //se o Cadadastro for chamado sem id.. ele ainda nao tem cadastro
    verifica();
  }

  //Verifica
  void verifica() {
    print('\n\n\n\nCadastro - Verifica()\n\n\n\n');
    if (g.dadosUser = true) {
      //print('Primeiro If');
      setState(() {
        //uid = g.id;
        _nome = new TextEditingController(text: g.nome);
        _email = new TextEditingController(text: g.email);
        _cpfcnpj = new TextEditingController(text: g.cpfcnpj);
        _telefone = new TextEditingController(text: g.telefone);
        _photoUrl = (g.photourl);
      });
    } else {
      //print('Segundo If');
      //esse email ja vem da autenticação(widget.user.email)

      setState(() {
        nome = g.nome;
        email = g.email;
        cpfcnpj = ''; //_u.cpfcnpj;
        telefone = ''; //_u.telefone;
        _photoUrl = g.photoAuth ?? null; //.photourl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.authUser) {
      return new Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Dados do Usuário'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Color(0xff1c2634),
        ),
        body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
            key: _formKey,
            child: new SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            onTap: tirarFoto,
                            child: Container(
                              width: 170.0,
                              height: 170.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider(
                                        _photoUrl ?? null)),
                              ),
                            ),
                          )),
                    ],
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

                  //Campo nome
                  EnsureVisibleWhenFocused(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 90,
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      //Nome
                      child: TextFormField(
                        //passa para o proximo campo
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          _proximoCampo(context, _focusNome, _focusEmail);
                        },
                        focusNode: _focusNome,
                        onSaved: (value) {
                          setState(() {
                            nome = value;
                          });
                        },
                        validator: (val) =>
                            val.isEmpty ? 'Nome não pode ser vazio.' : null,
                        keyboardType: TextInputType.text,
                        controller: _nome,
                        decoration: InputDecoration(
                          labelText: 'Nome *',
                          icon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    focusNode: _focusNome,
                  ),
                  //Fim campo nome

                  //Campo Email
                  EnsureVisibleWhenFocused(
                    focusNode: _focusEmail,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 90,
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      //Email
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          _proximoCampo(context, _focusEmail, _focusCPFCNPJ);
                        },
                        onSaved: (value) => email = value,
                        controller: _email,
                        validator: (val) =>
                            !val.contains('@') ? 'Endereço invalido.' : null,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'E-mail *',
                            hintText: 'email@exemplo.com',
                            icon: Icon(Icons.email)),
                        focusNode: _focusEmail,
                      ),
                    ),
                  ),
                  //Fim campo Email

                  //Campo CPF CNPJ
                  EnsureVisibleWhenFocused(
                    focusNode: _focusCPFCNPJ,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 90,
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      //CPF/CNPJ
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          _proximoCampo(context, _focusCPFCNPJ, _focusTelefone);
                        },
                        keyboardType: TextInputType.number,
                        onSaved: (value) => cpfcnpj = value,
                        controller: _cpfcnpj,
                        decoration: InputDecoration(
                            labelText: 'CPF/CNPJ *', icon: Icon(Icons.dehaze)),
                        focusNode: _focusCPFCNPJ,
                      ),
                    ),
                  ),
                  //Fim Campo CPF CNPJ

                  //Campo telefone
                  EnsureVisibleWhenFocused(
                    focusNode: _focusTelefone,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 90,
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          onSaved: (value) => telefone = value,
                          controller: _telefone,
                          decoration: InputDecoration(
                              labelText: 'Telefone *', icon: Icon(Icons.phone)),
                        )),
                  ),
                  //Fim campo telefone

                  const SizedBox(height: 24.0),

                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 12),
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: 50,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50)),
                      color: Color(0xff1f631b),
                      onPressed: () {
                        //Define as novas alterações para as var globais
                        g.nome = _nome.text;
                        g.email = _email.text;
                        g.cpfcnpj = _cpfcnpj.text;
                        g.telefone = _telefone.text;
                        //validação
                        db
                            .criarUsuario(_email.text, _nome.text, _email.text,
                                _cpfcnpj.text, _telefone.text, _photoUrl)
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
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return ListarProdutosPrincipal();
    }
  }
}

_proximoCampo(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
