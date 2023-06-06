import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/models/primary/user.dart';

class UserHelper extends anxeb.ModelHelper<UserModel> {
  Future showQR() async {
    await scope.dialogs.qr(model.id, icon: Icons.person, title: model.fullName, size: 300, buttons: [
      anxeb.DialogButton('Cerrar', false),
    ]).show();
  }

  @override
  Future<UserModel> delete({Future Function(UserHelper) success}) async {
    if (model.id != null) {
      var result = await scope.dialogs
          .confirm(
              'Está apunto de eliminar el usuario:\n\n  👤 ${model.fullName}\n  ✉️ ${model.login.email}\n\n¿Está seguro que quiere continuar?')
          .show();
      if (result == true) {
        try {
          await scope.busy();
          await scope.api.delete('/users/${model.id}');
          scope.rasterize(() {
            model.$deleted = true;
          });
          return await success?.call(this) != false ? model : null;
        } catch (err) {
          scope.alerts.error(err).show();
        } finally {
          await scope.idle();
        }
      }
    }
    return null;
  }

  Future<UserModel> update({Future Function(UserHelper) success, Future Function(UserHelper) next, bool silent}) async {
    if (silent != true) {
      await scope.busy(text: '${model.$exists ? 'Actualizando' : 'Creando'} Usuario...');
    }

    try {
      final data = await scope.api.post('/users', {'user': model.toObjects()});
      scope.rasterize(() {
        model.update(data);
      });
      await next?.call(this);
      if (silent != true) {
        await scope.idle();
      }
      return await success?.call(this) != false ? model : null;
    } catch (err) {
      scope.alerts.error(err).show();
    } finally {
      if (silent != true) {
        await scope.idle();
      }
    }
    return null;
  }

  Future<UserModel> fetch(
      {String id, Future Function(UserHelper) success, Future Function(UserHelper) next, bool silent}) async {
    if (silent != true) {
      await scope.busy(text: 'Cargando Usuario...');
    }

    try {
      final data = await scope.api.get('/users/${id ?? model.id}');
      scope.rasterize(() {
        model.update(data);
      });
      await next?.call(this);
      if (silent != true) {
        await scope.idle();
      }
      return await success?.call(this) != false ? model : null;
    } catch (err) {
      scope.alerts.error(err).show();
    } finally {
      if (silent != true) {
        await scope.idle();
      }
    }
    return null;
  }

  Future<bool> confirmPassword(String password,
      {Future Function(UserHelper) next, bool silent, bool throwError}) async {
    if (silent != true) {
      await scope.busy();
    }
    try {
      await scope.api.post('/auth/confirm', {'password': password});
      await next?.call(this);
      if (silent != true) {
        await scope.idle();
      }
      return true;
    } catch (err) {
      if (throwError == true) {
        rethrow;
      }
      scope.alerts.error(err).show();
    } finally {
      if (silent != true) {
        await scope.idle();
      }
    }
    return false;
  }

  Future<UserModel> setPassword(
      {@required String newPassword,
      @required String oldPassword,
      Future Function(dynamic helper) success,
      Future Function(UserHelper) next,
      bool silent}) async {
    if (silent != true) {
      await scope.busy();
    }
    try {
      await scope.api.post('/profile', {
        'password_old': oldPassword,
        'password_new': newPassword,
      });
      if (silent != true) {
        await scope.idle();
      }
      return await success?.call(this) != false ? model : null;
    } catch (err) {
      scope.alerts.error(err).show();
    } finally {
      if (silent != true) {
        await scope.idle();
      }
    }
    return null;
  }
}
