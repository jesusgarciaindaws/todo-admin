import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/middleware/session.dart';

class HeaderComponent extends StatefulWidget {
  final Application application;

  const HeaderComponent({Key key, this.application}) : super(key: key);

  @override
  createState() => _HeaderComponentState();
}

class _HeaderComponentState extends State<HeaderComponent> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 0)).then((value) => mounted == true ? setState(() {}) : null);

    return Container(
      height: 80,
      color: Global.settings.headerFillColor,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Image(
              image: AssetImage('assets/images/brand/color-horizontal-white.png'),
              height: 50,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(right: 16, bottom: 4),
              child: session?.user != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          session.user.fullName,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w200,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 14, right: 4, bottom: 1),
                              child: const Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            Text(
                              Global.captions.userRole(session.user.role).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 14, right: 4, bottom: 1),
                              child: const Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            Text(
                              session.user.login.email.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                anxeb.ImageButton(
                  height: 48,
                  width: 48,
                  imageUrl: application.api.getUri('/storage/profile/avatar?t=${session.tick}&width=200'),
                  innerPadding: const EdgeInsets.all(0),
                  headers: {'Authorization': 'Bearer ${application.api.token}'},
                  outerBorderColor: Colors.transparent,
                  loadingColor: Colors.white.withOpacity(0.5),
                  loadingThickness: 4,
                  outerThickness: 0,
                  failedBody: anxeb.IconButton(
                    keyless: true,
                    icon: anxeb.CommunityMaterialIcons.account_edit,
                    iconSize: 32,
                    enabled: true,
                    action: () async {
                      application.middleware.scope.go('/profile');
                    },
                  ),
                  onTap: () async {
                    application.middleware.scope.go('/profile');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  PageMeta get meta => middleware.info.meta;

  anxeb.PageInfo<Application, PageMeta> get info => widget.application.middleware.info;

  Application get application => widget.application;

  anxeb.PageMiddleware<Application, PageMeta> get middleware => widget.application.middleware;

  Session get session => application.session;
}
