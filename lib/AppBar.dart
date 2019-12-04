import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final List<Widget> widgets;

  const BaseAppBar({Key key, this.appBar, this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text('iCollection',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Color(0xff1c2634),
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
