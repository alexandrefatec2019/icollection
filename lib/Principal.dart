import 'package:flutter/material.dart';
import 'package:icollection/AppBar.dart';

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // AppBar
    var estiloNome = TextStyle(color: Colors.blue[900], fontSize: 18.0);
    var nome = Text("Tony Stark", style: estiloNome);

    // ligar:
    var iconeLigar = Icon(Icons.call, size: 40.0, color: Colors.green);
    var textoLigar = Text("Ligar");
    var colunaLigar = Column(
      children: [iconeLigar, textoLigar],
    );

    // email:
    var iconeEmail = Icon(Icons.email, size: 40.0, color: Colors.red);
    var textoEmail = Text("E-mail");
    var colunaEmail = Column(children: [iconeEmail, textoEmail]);

    var linha = Row(
      children: [colunaLigar, colunaEmail],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );

    var bio = Text(
        "Homem de Ferro (Iron Man, em inglês) é um personagem fictício dos quadrinhos publicados pela Marvel Comics. Sua identidade verdadeira é a do empresário e bilionário Tony Stark, que usa armaduras de alta tecnologia no combate ao crime. Foi criado em 1963 pelo escritor Stan Lee, o roteirista Larry Lieber, e os desenhistas Jack Kirby e Don Heck. O objetivo de seu criador, Stan Lee, era aceitar o desafio de fazer um personagem ser odiado e depois amado pelo público, assim, criou um dos super heróis mais marcantes de todos os tempos.");

    var listaTexto = ListView(
      children: [bio],
    );

    var expandido = Expanded(child: listaTexto);

    var coluna = Column(
        children: [nome, linha, expandido],
        crossAxisAlignment: CrossAxisAlignment.start);

    // Scaffold:
    var scaffold = Scaffold(
      body: null,
      appBar: BaseAppBar(
        appBar: AppBar(
          ),
        widgets: <Widget>[
          //Items que serão exibidos na AppBar
          IconButton(icon: new Icon(Icons.search),
              onPressed: (){},
              ),
        ],
      ),
    );

    return scaffold;
  }
}
