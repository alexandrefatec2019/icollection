import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

class EnsureVisibleWhenFocused extends StatefulWidget {
  const EnsureVisibleWhenFocused({
    Key key,
    @required this.child,
    @required this.focusNode,
    this.curve: Curves.ease,
    this.duration: const Duration(milliseconds: 100),
  }) : super(key: key);

  final FocusNode focusNode;

  final Widget child;

  final Curve curve;

  final Duration duration;

  @override
  _EnsureVisibleWhenFocusedState createState() => new _EnsureVisibleWhenFocusedState();
}

class _EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused> with WidgetsBindingObserver  {

  @override
  void initState(){
    super.initState();
    widget.focusNode.addListener(_ensureVisible);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    widget.focusNode.removeListener(_ensureVisible);
    super.dispose();
  }

  @override
  void didChangeMetrics(){
    if (widget.focusNode.hasFocus){
      _ensureVisible();
    }
  }

  Future<Null> _keyboardToggled() async {
    if (mounted){
      EdgeInsets edgeInsets = MediaQuery.of(context).viewInsets;
      while (mounted && MediaQuery.of(context).viewInsets == edgeInsets) {
        await new Future.delayed(const Duration(milliseconds: 10));
      }
    }

    return;
  }

  Future<Null> _ensureVisible() async {
    await Future.any([new Future.delayed(const Duration(milliseconds: 300)), _keyboardToggled()]);

    if (!widget.focusNode.hasFocus){
      return;
    }

    final RenderObject object = context.findRenderObject();
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);

    if (viewport == null) {
        return;
    }

    ScrollableState scrollableState = Scrollable.of(context);
    assert(scrollableState != null);

    ScrollPosition position = scrollableState.position;
    double alignment;

    if (position.pixels > viewport.getOffsetToReveal(object, 0.0).offset) {
      alignment = 0.0;
    } else if (position.pixels < viewport.getOffsetToReveal(object, 1.0).offset){
      alignment = 1.0;
    } else {
      return;
    }

    position.ensureVisible(
      object,
      alignment: alignment,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}