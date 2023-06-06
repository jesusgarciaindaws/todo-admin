import 'package:flutter/material.dart';
import 'package:control_style/control_style.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/global.dart';

class GlobalThemes {
  final loginFields = anxeb.FieldWidgetTheme(
    fillColor: Colors.white,
    inputStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    labelStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    isDense: false,
    borderless: true,
    borderRadius: Global.settings.generalRadius,
    contentPaddingWithIcon: const EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 0),
    contentPaddingNoIcon: const EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 0),
    focusColor: const Color(0xffffffff),
    border: DecoratedInputBorder(
      isOutline: false,
      child: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      shadow: const [
        BoxShadow(
          color: Color(0x25abb1db),
          blurRadius: 6,
          spreadRadius: 4,
          offset: Offset(0, 2),
        )
      ],
    ),
  );

  final field = anxeb.FieldWidgetTheme(
    fillColor: Colors.white,
    inputStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    labelStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    contentPaddingWithIcon: const EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 0),
    contentPaddingNoIcon: const EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 0),
    focusColor: const Color(0xffffffff),
    border: DecoratedInputBorder(
      isOutline: false,
      child: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      shadow: const [
        BoxShadow(
          color: Color(0x25abb1db),
          blurRadius: 6,
          spreadRadius: 4,
          offset: Offset(0, 2),
        )
      ],
    ),
  );

  final text = anxeb.FieldWidgetTheme(fontSize: 16, prefixIconSize: 20);
}
