import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/forms/credentials.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/middleware/session.dart';
import 'package:todo_admin/middleware/application.dart';

class ProfilePage extends anxeb.PageWidget<Application, PageMeta> {
  ProfilePage({Key key}) : super('profile', key: key, path: 'profile');

  @override
  PageMeta meta() => PageMeta(icon: Icons.person_rounded);

  @override
  createState() => _ProfileState();

  @override
  String title({anxeb.GoRouterState state}) => 'Mi Perfil';
}

class _ProfileState extends anxeb.PageView<ProfilePage, Application, PageMeta> {
  @override
  Future init() async {}

  @override
  void setup() async {
    meta.subtitle = 'Perfil personal de usuario actual';
    meta.menu = _getMenu;
  }

  @override
  void prebuild() {}

  @override
  Widget content() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                anxeb.ImageButton(
                  height: 80,
                  width: 80,
                  imageUrl: application.api.getUri('/storage/profile/avatar?t=${scope.tick}&width=200'),
                  innerPadding: const EdgeInsets.all(0),
                  headers: {'Authorization': 'Bearer ${scope.application.api.token}'},
                  margin: const EdgeInsets.only(right: 8),
                  outerBorderColor: Colors.transparent,
                  failedIcon: Icons.account_circle,
                  loadingColor: scope.application.settings.colors.primary.withOpacity(0.5),
                  loadingThickness: 4,
                  outerThickness: 0,
                  failedIconColor: scope.application.settings.colors.primary.withOpacity(0.3),
                  onTap: () async {
                    _updatePhoto();
                  },
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.user.fullName,
                style: TextStyle(
                  fontSize: 40,
                  letterSpacing: -0.2,
                  color: settings.colors.text,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                session.user.login.email,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: settings.colors.secudary,
                  letterSpacing: -0.4,
                ),
                overflow: TextOverflow.clip,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getMenu() {
    return Row(
      children: [
        anxeb.MenuButton(
          scope: scope,
          caption: 'Cambiar Contraseña',
          icon: anxeb.CommunityMaterialIcons.key,
          margin: const EdgeInsets.only(right: 4),
          onTap: _updatePassword,
        ),
      ],
    );
  }

  void _updatePhoto() async {
    scope.unfocus();
    final fileData = await anxeb.Device.browse<Uint8List>(
      scope: scope,
      type: anxeb.FileType.image,
      allowMultiple: false,
      withData: true,
      showBusyOnPicking: false,
      callback: (files) async {
        return files.single.bytes;
      },
    );

    if (fileData?.isNotEmpty == true) {
      await scope.busy();
      try {
        var b64 = base64Encode(fileData);
        await session.api.post('/profile/avatar', {'picture': 'data:image/png;base64,$b64'});
        await session.renew(scope: scope);
        scope.retick();
        scope.rasterize();
        scope.alerts.success('Foto de perfil actualizada correctamente').show();
      } catch (err) {
        scope.alerts.error(err).show();
      } finally {
        await scope.idle();
      }
    }
  }

  void _updatePassword() async {
    final form = CredentialsForm(scope: scope, user: session.user);
    final result = await form.show();
    if (result != null) {
      rasterize(() {
        session.user.update(result);
      });
    }
  }

  Session get session => application.session;
}
