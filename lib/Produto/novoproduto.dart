import 'package:flutter/material.dart';

class NovoProduto extends StatefulWidget {
  @override
  _NovoProdutoState createState() => _NovoProdutoState();
}

class _NovoProdutoState extends State<NovoProduto> {
  final _formKey = GlobalKey<FormState>();

  //TODO - Pagina NovoProduto - Pegar info do Model ou Data do Produto
  String _nomeProduto = '';
  String _descricao = '';
  bool _troca = false;
  int _estadoSelecionado = null;
  List<DropdownMenuItem<int>> estadoList = [];

  void loadEstadoList() {
    estadoList = [];
    estadoList.add(new DropdownMenuItem(
      child: new Text('Novo'),
      value: 0,
    ));
    estadoList.add(new DropdownMenuItem(
      child: new Text('Usado'),
      value: 1,
    ));
    estadoList.add(new DropdownMenuItem(
      child: new Text('Seminovo'),
      value: 2,
    ));
    estadoList.add(new DropdownMenuItem(
      child: new Text('Restaurado'),
      value: 3,
    ));
  }

  @override
  Widget build(BuildContext context) {
    loadEstadoList();
    return Scaffold(
      appBar: AppBar(
           backgroundColor: Color(0xff1c2634),
          title: Text('Novo Anúncio'),
          centerTitle: true,
         ),
      body: Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(15.0),
        children: getFormWidget(),
      )
      ),
    );
  }
  List<Widget> getFormWidget(){
    List<Widget> formWidget = new List();

    //---------- NOME DO PRODUTO ---------- 
     formWidget.add(new TextFormField(
       keyboardType: TextInputType.text,
       decoration: InputDecoration(
         labelText: 'Nome do Produto:',
       ),
       validator: (value) {
        if (value.isEmpty) {
          return 'Digite um Nome para o produto';
        }
       },
       onSaved: (value) {
        setState(() {
          _nomeProduto = value;
        });
      },
     ),
    );

    //---------- DESCRIÇÃO ---------- 
    formWidget.add(
      new TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Descrição:',
        ),
        validator: (value){
          if(value.isEmpty){
            return 'Escreva a descrição do produto';
          }
        },
        onSaved: (value){
          setState(() {
           _descricao = value; 
          });
        },
      )
    );

    //---------- MATERIAL ---------- 
    formWidget.add(
      new TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Material do Produto:',
        ),
        validator: (value){
          if(value.isEmpty){
            return 'Escreva o material do produto';
          }
        },
        onSaved: (value){
          setState(() {
           _descricao = value; 
          });
        },
      )
    );
    formWidget.add(new Padding(
      padding: EdgeInsets.all(5)
    )
    );
    //---------- ESTADO DO PRODUTO ----------
    formWidget.add(
      new DropdownButton(
      hint: new Text('Estado do Produto:'),
      items: estadoList,
      value: _estadoSelecionado,
      onChanged: (value) {
        setState(() {
          _estadoSelecionado = value;
        });
      },
      isExpanded: true,
    ));

    //---------- VALOR R$ ----------
    formWidget.add(
      new TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Valor (R\$):',
        ),
        validator: (value){
          if(value.isEmpty){
            return 'Digite o valor do produto';
          }
        },
        onSaved: (value){
          setState(() {
           _descricao = value; 
          });
        },
      )
    );

    //---------- DISPONIBILIDADE TROCA ----------
    formWidget.add(
      new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
                      padding: new EdgeInsets.all(10.0),
                    ),
            new Text('Disponibilidade para Troca:', style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<bool>(
            // title: const Text('Não'),
            value: false,
            groupValue: _troca,
            onChanged: (value){
              setState(() {
               _troca = value; 
              });
            },
          ),
          new Text('Não', style: TextStyle(
                color: Colors.grey[600],
              ),
          ),
          Radio<bool>(
            // title: const Text('Sim'),
            value: true,
            groupValue: _troca,
            onChanged: (value){
              setState(() {
               _troca = value; 
              });
            },
          ),
          new Text('Sim', style: TextStyle(
                color: Colors.grey[600],
              ),
          ),
              ],
            )
          ],
        ),
      )
    );

    //---------- IMAGENS ----------
    formWidget.add(
      new Container(
        child: SizedBox(
          child: Column(
            children: <Widget>[
              new Divider(height: 20, color: Colors.grey[300],),
              new Padding(padding: EdgeInsets.all(5),),
              new Text('Imagens:', style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                ),
              ),
              new Padding(padding: EdgeInsets.all(10),),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Card(
                    child: InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.width/2,
                        width: MediaQuery.of(context).size.width/2.7,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.width/2,
                        width: MediaQuery.of(context).size.width/2.7,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Card(
                    child: InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.width/2,
                        width: MediaQuery.of(context).size.width/2.7,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.width/2,
                        width: MediaQuery.of(context).size.width/2.7,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Card(
                    child: InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.width/2,
                        width: MediaQuery.of(context).size.width/2.7,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.width/2,
                        width: MediaQuery.of(context).size.width/2.7,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      )
    );

    formWidget.add(new Padding(
      padding: EdgeInsets.all(6),
    )
    );

    //---------- BOTÃO CONFIRMAR ----------
    formWidget.add(new FloatingActionButton.extended(
        onPressed: (){
          
        },
        icon: Icon(Icons.done),
        label: Text('Criar Anúncio'),
        backgroundColor: Colors.green,
      ),    
    );
    return formWidget;
  }
}