import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TranserBlock extends StatefulWidget {
  final Widget child;
  final bool visible;

  const TranserBlock({
    Key key,
    @required this.child,
    @required this.visible,
  }) : super(key: key);

  @override
  createState() => _TranserBlockState();
}

class _TranserBlockState extends State<TranserBlock> {
  bool _disabled = true;

  @override
  Widget build(BuildContext context) {
    if (widget.visible == true) {
      _disabled = false;
    }

    return SafeArea(
      bottom: true,
      top: false,
      child: Container(
        padding: const EdgeInsets.only(bottom: 60),
        child: AnimatedOpacity(
          opacity: widget.visible ? 1.0 : 0.0,
          onEnd: () {
            if (widget.visible == false) {
              setState(() {
                _disabled = true;
              });
            }
          },
          duration: const Duration(milliseconds: 300),
          child: _disabled == true ? Container() : widget.child,
        ),
      ),
    );
  }
}
