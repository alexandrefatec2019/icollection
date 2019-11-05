import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:icollection/Principal.dart';
import 'package:icollection/Usuario/UsuarioDATA.dart';
import 'package:icollection/model/usuarioModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

//cuida da sobreposição do teclado
import 'ensure.dart';

class CadDados extends StatefulWidget {
  final UsuarioModel user;
  CadDados(this.user);

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
  String _photoUrl;

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
        maxHeight: 800,
        maxWidth: 600);

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
      _photoUrl = url.toString();
      this.uploading = false;
    });

    return url;
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();

    //se o Cadadastro for chamado sem id.. ele ainda nao tem cadastro

    if (widget.user.id == null) {
      uid = widget.user.id;
      _nome = new TextEditingController(text: widget.user.nome);
      _email = new TextEditingController(text: widget.user.email);
      _cpfcnpj = new TextEditingController(text: widget.user.cpfcnpj);
      _telefone = new TextEditingController(text: widget.user?.telefone);
      _photoUrl = (widget.user.photourl);
    } else {
      
      //esse email ja vem da autenticação(widget.user.email)
      db.lerUsuario(widget.user.email).then((_u) {
        nome = _u.nome;
        email = _u.email;
        cpfcnpj = _u.cpfcnpj;
        telefone = _u.telefone;
        _photoUrl = _u.photourl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(_photoUrl),
                            radius: 100,
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
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
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
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
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
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
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
                FloatingActionButton(
                  onPressed: () {
                    db.lerUsuario('gruposjrp@gmail.com');
                  },
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_proximoCampo(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
