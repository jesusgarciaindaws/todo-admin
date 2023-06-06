import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/models/common/identity.dart';
import 'package:todo_admin/models/common/login.dart';
import 'package:todo_admin/models/primary/user.dart';

class UserForm extends anxeb.FormDialog<UserModel, Application> {
  UserModel _user;
  UserRole _role;

  UserForm({@required anxeb.Scope scope, UserModel user, UserRole role})
      : super(
          scope,
          model: user,
          dismissable: true,
          title: user == null ? 'Nuevo Usuario' : 'Editar Usuario',
          subtitle: user?.fullName,
          icon: user == null ? Icons.person_add : anxeb.CommunityMaterialIcons.account_edit,
          width: Global.settings.mediumFormWidth,
        ) {
    _role = role;
  }

  @override
  void init(anxeb.FormScope scope) {
    _user = UserModel();
    _user.update(model);
  }

  @override
  Widget body(anxeb.FormScope scope) {
    return Column(
      children: [
        anxeb.FormRowContainer(
          scope: scope,
          fields: [
            Expanded(
              child: anxeb.TextInputField(
                scope: scope,
                name: 'first_names',
                group: 'user',
                icon: Icons.text_fields,
                fetcher: () => _user.firstNames,
                label: 'Nombre',
                type: anxeb.TextInputFieldType.text,
                validator: anxeb.Utils.validators.firstNames,
                applier: (value) => _user.firstNames = value,
                autofocus: true,
              ),
            ),
            anxeb.FormSpacer(),
            Expanded(
              child: anxeb.TextInputField(
                scope: scope,
                name: 'last_names',
                group: 'user',
                icon: Icons.text_fields,
                fetcher: () => _user.lastNames,
                label: 'Apellido',
                type: anxeb.TextInputFieldType.text,
                validator: anxeb.Utils.validators.lastNames,
                applier: (value) => _user.lastNames = value,
              ),
            ),
            anxeb.FormSpacer(),
            Expanded(
              child: anxeb.OptionsInputField<LoginState>(
                scope: scope,
                name: 'state',
                group: 'user',
                icon: Icons.no_accounts_rounded,
                fetcher: () => _user.login.state,
                label: 'Estado',
                validator: anxeb.Utils.validators.required,
                options: () async => LoginState.values,
                displayText: (state) => Global.captions.loginState(state),
                displayIcon: (state) => state == LoginState.active ? Icons.account_circle_rounded : null,
                applier: (value) => _user.login.state = value,
              ),
            ),
          ],
        ),
        anxeb.FormRowContainer(
          scope: scope,
          title: 'Información Administrativa',
          fields: [
            Expanded(
              child: anxeb.OptionsInputField<IdentityType>(
                scope: scope,
                name: 'identity_type',
                group: 'user',
                icon: Icons.account_box,
                fetcher: () => _user.info?.identity?.type,
                label: 'Tipo Identidad',
                options: () async => IdentityType.values,
                displayText: (type) => Global.captions.identityType(type),
                onValidSubmit: (value) => scope.rasterize(() => _user.info.identity.type = value),
                applier: (value) => _user.info.identity.type = value,
              ),
            ),
            anxeb.FormSpacer(),
            Expanded(
              child: anxeb.TextInputField(
                scope: scope,
                name: 'identity_number',
                group: 'user',
                icon:
                    _user.info.identity?.type == IdentityType.company ? Icons.account_balance_sharp : Icons.fingerprint,
                fetcher: () => _user.info.identity.number,
                label: Global.captions.identityType(_user.info.identity.type) ?? 'Identidad',
                type: anxeb.TextInputFieldType.text,
                applier: (value) => _user.info.identity.number = value,
              ),
            ),
            anxeb.FormSpacer(),
            Expanded(
              child: anxeb.OptionsInputField<UserRole>(
                scope: scope,
                name: 'role',
                group: 'user',
                icon: Icons.shield_rounded,
                fetcher: () => _user.role,
                label: 'Rol',
                options: () async => UserRole.values,
                displayText: (value) => Global.captions.userRole(value),
                onValidSubmit: (value) => scope.rasterize(() => _user.role = value),
                applier: (value) => _user.role = value,
              ),
            ),
          ],
        ),
        anxeb.FormRowContainer(
          scope: scope,
          title: 'Datos de Acceso',
          fields: [
            Expanded(
              flex: 2,
              child: anxeb.TextInputField(
                scope: scope,
                name: 'login_email',
                group: 'user',
                icon: Icons.email,
                fetcher: () => _user.login.email,
                label: 'Correo',
                type: anxeb.TextInputFieldType.email,
                validator: anxeb.Utils.validators.email,
                applier: (value) => _user.login.email = value,
              ),
            ),
            anxeb.FormSpacer(),
            Expanded(
              flex: 1,
              child: anxeb.TextInputField(
                scope: scope,
                name: 'login_password',
                group: 'user',
                icon: Icons.key,
                label: 'Contraseña',
                type: anxeb.TextInputFieldType.password,
                applier: (value) => _user.login.password = value,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  List<anxeb.FormButton> buttons(anxeb.FormScope<Application> scope) {
    return [
      anxeb.FormButton(
        caption: 'Eliminar',
        visible: exists && model.id != scope.application.session.user.id,
        onTap: (anxeb.FormScope scope) => _delete(scope),
        fillColor: scope.application.settings.colors.danger,
        icon: Icons.delete,
        rightDivisor: true,
      ),
      anxeb.FormButton(
        caption: 'Guardar',
        onTap: (anxeb.FormScope scope) => _persist(scope),
        icon: Icons.check,
      ),
      anxeb.FormButton(
        caption: exists ? 'Cerrar' : 'Cancelar',
        onTap: (anxeb.Scope scope) async => true,
        icon: Icons.close,
      )
    ];
  }

  Future _delete(anxeb.FormScope scope) async {
    return await _user.using(scope).delete(success: (helper) async {
      scope.parent.alerts.success('Usuario eliminado exitosamente').show();
    });
  }

  Future _persist(anxeb.FormScope scope) async {
    final form = scope.forms['user'];
    if (form.valid(autoFocus: true)) {
      if (_role != null) {
        _user.role = _role;
      }

      return await _user.using(scope).update(success: (helper) async {
        if (exists) {
          scope.parent.alerts.success('Usuario actualizado exitosamente').show();
          scope.parent.rasterize(() {
            model.update(_user);
          });
        } else {
          scope.parent.alerts.success('Usuario creado exitosamente').show();
        }
      });
    }
  }

  @override
  Future Function(anxeb.FormScope scope) get close => (scope) async => true;
}
