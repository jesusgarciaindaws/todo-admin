import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/models/primary/reference.dart';

class ReferenceHelper extends anxeb.ModelHelper<ReferenceModel> {
  @override
  Future<ReferenceModel> delete({Future Function(ReferenceHelper) success}) async {
    if (model.id != null) {
      var result = await scope.dialogs
          .confirm('Está apunto de eliminar ${model.name}\n\n¿Está seguro que quiere continuar?')
          .show();
      if (result == true) {
        try {
          await scope.busy();
          await scope.api.delete('/references/${model.id}');
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

  Future<ReferenceModel> update(
      {Future Function(ReferenceHelper) success, Future Function(ReferenceHelper) next, bool silent}) async {
    if (silent != true) {
      await scope.busy(text: '${model.$exists ? 'Actualizando' : 'Creando'} Referencia...');
    }

    try {
      final data = await scope.api.post('/references', {'reference': model.toObjects(usePrimaryKeys: true)});
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

  Future<ReferenceModel> fetch(
      {Future Function(ReferenceHelper) success, Future Function(ReferenceHelper) next, bool silent}) async {
    if (silent != true) {
      await scope.busy(text: 'Cargando Referencia...');
    }

    try {
      final data = await scope.api.get('/references/${model.id}');
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

  Future<ReferenceModel> edit({Future Function(ReferenceHelper) success, bool persist}) async {
    final result = await scope.dialogs.form('Crear ${Global.captions.referenceType(model.finalType) ?? 'Elemento'}',
        icon: Global.icons.referenceType(model.finalType) ?? Icons.list_alt_rounded,
        width: Global.settings.smallFormWidth,
        dismissible: true, fields: (scope, context, group, accept, cancel) {
      return [
        anxeb.TextInputField<String>(
          scope: scope,
          group: group,
          name: 'name',
          margin: const EdgeInsets.only(top: 10),
          label: 'Indique nombre de ${Global.captions.referenceType(model?.finalType).toLowerCase() ?? 'elemento'}',
          fetcher: () => model.name,
          validator: anxeb.Utils.validators.required,
          action: TextInputAction.go,
          onActionSubmit: (val) => accept(),
          type: anxeb.TextInputFieldType.text,
          autofocus: true,
          focusNext: true,
        ),
      ];
    }).show();

    if (result != null && result['name']?.toString()?.isNotEmpty == true) {
      model.name = result['name'];
      if (persist == true) {
        return await update(success: success);
      } else {
        return await success?.call(this) != false ? model : null;
      }
    }
    return null;
  }
}
