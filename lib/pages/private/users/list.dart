import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/forms/user.dart';
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/middleware/session.dart';
import 'package:todo_admin/models/primary/user.dart';
import 'package:todo_admin/widgets/rows/user.dart';
import 'package:todo_admin/middleware/application.dart';

class UsersPage extends anxeb.PageWidget<Application, PageMeta> {
  UsersPage({Key key}) : super('users', key: key, path: 'users');

  @override
  PageMeta meta() => PageMeta(icon: Global.icons.users);

  @override
  createState() => _UsersState();

  @override
  String title({anxeb.GoRouterState state}) => 'Usuarios Administradores';
}

class _UsersState extends anxeb.PageView<UsersPage, Application, PageMeta> {
  List<UserModel> _users;
  ScrollController _scrollController;
  bool _refreshing;
  String _lookup;

  @override
  Future init() async {
    _scrollController = ScrollController();
    _refresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void setup() async {
    meta.menu = _getMenu;
    meta.onSearch = (text) {
      rasterize(() {
        _lookup = text;
      });
    };

    if (info?.state?.queryParams != null && info?.state?.queryParams['refresh'] == 'true') {
      _refresh();
    }
  }

  @override
  void prebuild() {}

  @override
  Widget content() {
    return _getList();
  }

  Widget _getMenu() {
    return Row(
      children: [
        anxeb.MenuButton(
          scope: scope,
          caption: 'Refrescar',
          icon: Icons.refresh,
          margin: const EdgeInsets.only(right: 4),
          onTap: _refresh,
        ),
        anxeb.MenuButton(
          scope: scope,
          caption: 'Agregar',
          icon: Icons.add,
          onTap: _add,
        ),
      ],
    );
  }

  Future _refresh({bool uncatched, bool jump, bool silent}) async {
    if (silent != true) {
      rasterize(() {
        _refreshing = true;
      });
    }
    try {
      if (uncatched != true && silent != true) {
        await scope.busy();
      }
      scope.retick();
      final data = await session.api.get('/users');
      _users = data.list((data) => UserModel(data));

      if (_users.isEmpty) {
        meta.subtitle = 'Registro de usuarios del sistema';
      } else if (_users.length == 1) {
        meta.subtitle = 'Existe un usuario registrado';
      } else {
        meta.subtitle = 'Existen ${_users.length} usuarios registrados';
      }

      if (jump == true && _scrollController.hasClients) {
        _scrollController.position.jumpTo(0);
      }
    } catch (err) {
      if (uncatched != true) {
        if (silent != true) {
          scope.alerts.error(err).show();
        }
      } else {
        rethrow;
      }
    } finally {
      if (uncatched != true && silent != true) {
        await scope.idle();
      }
    }

    rasterize(() {
      _refreshing = false;
    });
  }

  Widget _getList() {
    if (users == null && _refreshing == true) {
      return anxeb.EmptyBlock(
        scope: scope,
        message: 'Cargando usuarios...',
        icon: Icons.sync,
      );
    }

    if (users == null) {
      return anxeb.EmptyBlock(
        scope: scope,
        message: 'Error cargando usuarios',
        icon: Icons.cloud_off,
        actionText: 'Refrescar',
        actionCallback: () async => _refresh(),
      );
    }

    if (users.isEmpty) {
      return anxeb.EmptyBlock(
        scope: scope,
        message: 'No existen usuarios',
        icon: anxeb.Octicons.info,
        actionText: 'Refrescar',
        actionCallback: () async => _refresh(),
      );
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      children: users
          .map((item) =>
              UserListRow(scope: scope, user: item, onTap: () => _select(item), onDeleteTap: () => _delete(item)))
          .toList(),
    );
  }

  void _select(UserModel user) async {
    user.using(scope).fetch(success: (helper) async {
      final form = UserForm(scope: scope, user: user);
      final result = await form.show();
      if (result != null && result.$deleted == true) {
        rasterize(() {
          _users.remove(user);
        });
      }
    });
  }

  void _delete(UserModel user) async {
    final result = await user.using(scope).delete(success: (helper) async {
      scope.alerts.success('Usuario eliminado exitosamente').show();
    });
    if (result != null) {
      rasterize(() {
        _users.remove(user);
      });
    }
  }

  void _add() async {
    final form = UserForm(scope: scope);
    final result = await form.show();
    if (result != null) {
      rasterize(() {
        _users.add(result);
      });
      await Future.delayed(const Duration(milliseconds: 10));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      }
    }
  }

  List<UserModel> get users =>
      _users != null ? _users.where(($item) => $item.filter(lookup: _lookup)).toList() : _users;

  Session get session => application.session;
}
