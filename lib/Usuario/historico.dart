import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';


class Historico extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HistoricoState();
}
class HistoricoState extends State<Historico>{
  @override void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child:AppBar( 
                automaticallyImplyLeading: true,
                title: Text('Histórico'), centerTitle: true,
                leading: IconButton(icon:Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: Color(0xff1c2634),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: <Widget>[
                    Tab(text: 'Venda',),
                    Tab(text: 'Compra',),
                    Tab(text: 'Troca',),
                  ],
                ),
              ),
      ),
      body: TabBarView(
        children: <Widget>[
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.green,
          ),
          Container(
            color: Colors.blue,
          ),
        ],
      )
      )
      ); 


  }
}