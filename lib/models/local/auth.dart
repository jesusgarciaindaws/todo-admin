import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/helpers/auth.dart';
import 'package:todo_admin/models/primary/user.dart';

class SessionAuth extends anxeb.HelpedModel<SessionAuth, AuthHelper> {
  SessionAuth([data]) : super(data);

  @override
  void init() {
    field(() => user, (v) => user = v, 'user', instance: (data) => UserModel(data));
    field(() => roles, (v) => roles = v, 'roles', enumValues: AuthRoles.values, defect: () => <AuthRoles>[]);
    field(() => provider, (v) => provider = v, 'provider');
    field(() => token, (v) => token = v, 'token');
    field(() => flags, (v) => flags = v, 'flags', instance: (data) => SessionAuthFlagsModel(data));
  }

  @override
  AuthHelper helper() => AuthHelper();

  UserModel user;
  List<AuthRoles> roles;
  String provider;
  String token;
  SessionAuthFlagsModel flags;
}

class SessionAuthFlagsModel extends anxeb.Model<SessionAuthFlagsModel> {
  SessionAuthFlagsModel([data]) : super(data);

  @override
  void init() {}
}

enum AuthRoles { system_admin, app_client }
