import 'package:flutter/material.dart';

class PageMeta {
  List<String> roles = [];
  IconData icon;
  Widget Function() menu;
  Function(String text) onSearch;
  String subtitle;

  PageMeta({this.roles, this.icon, this.menu, this.subtitle});
}
