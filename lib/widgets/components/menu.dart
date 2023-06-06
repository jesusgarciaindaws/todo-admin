import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/middleware/session.dart';

class MenuComponent extends StatefulWidget {
  final Application application;

  const MenuComponent({Key key, this.application}) : super(key: key);

  @override
  createState() => _MenuComponentState();
}

class _MenuComponentState extends State<MenuComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 0)).then((value) => mounted == true ? setState(() {}) : null);

    return Container(
      alignment: Alignment.centerLeft,
      height: 65,
      child: Row(
        children: [
          middleware?.info?.meta?.icon != null
              ? Container(
                  padding: const EdgeInsets.only(left: 20, right: 14),
                  child: Icon(
                    middleware.info.meta.icon,
                    size: 38,
                    color: application.settings.colors.primary,
                  ),
                )
              : Container(padding: const EdgeInsets.only(left: 24)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info?.title ?? '',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: application.settings.colors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  decoration: TextDecoration.none,
                ),
              ),
              info?.meta?.subtitle != null
                  ? Text(
                      info.meta.subtitle ?? '',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: application.settings.colors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        decoration: TextDecoration.none,
                      ),
                    )
                  : Container(),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            padding: const EdgeInsets.only(right: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    _buildTopSearchBae(),
                    _buildTopMenu(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopMenu() {
    if (meta?.menu != null) {
      return meta.menu();
    } else {
      return Container();
    }
  }

  Widget _buildTopSearchBae() {
    if (meta?.onSearch != null) {
      return anxeb.MenuSearchButton(
        width: 500,
        margin: const EdgeInsets.only(right: 4),
        textColor: application.settings.colors.primary,
        buttonRadius: application.settings.dialogs.buttonRadius,
        hintTextColor: application.settings.colors.separator,
        onFieldSubmitted: (String text) => meta.onSearch(text),
        onCollapseComplete: () => meta.onSearch(null),
        speed: 250,
        hintText: 'Búsqueda',
      );
    } else {
      return Container();
    }
  }

  PageMeta get meta => middleware.info.meta;

  anxeb.PageInfo<Application, PageMeta> get info => widget.application.middleware.info;

  Application get application => widget.application;

  anxeb.PageMiddleware<Application, PageMeta> get middleware => widget.application.middleware;

  Session get session => application.session;
}
