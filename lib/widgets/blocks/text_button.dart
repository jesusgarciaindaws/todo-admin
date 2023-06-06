import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;

class TextButtonBlock extends StatelessWidget {
  final anxeb.Scope scope;
  final String text;
  final String labelKey;
  final Color fill;
  final Color foreground;
  final EdgeInsets margin;
  final VoidCallback onPressed;

  const TextButtonBlock({
    Key key,
    @required this.scope,
    this.text,
    this.labelKey,
    this.fill,
    this.foreground,
    this.margin,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return anxeb.TextButton(
      margin: margin,
      caption: text ?? anxeb.translate(labelKey),
      radius: 20,
      color: fill ?? scope.application.settings.colors.primary,
      padding: const EdgeInsets.all(16),
      textStyle: TextStyle(fontSize: 16, color: foreground ?? Colors.white, fontWeight: FontWeight.w600),
      type: anxeb.ButtonType.secundary,
      size: anxeb.ButtonSize.small,
      iconColor: foreground ?? Colors.white,
      onPressed: onPressed,
    );
  }
}
