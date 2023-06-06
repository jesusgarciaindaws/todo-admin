import 'package:anxeb_flutter/anxeb.dart' as anxeb;

class LoginModel extends anxeb.Model<LoginModel> {
  LoginModel([data]) : super(data);

  @override
  void init() {
    field(() => provider, (v) => provider = v, 'provider', enumValues: LoginProvider.values);
    field(() => email, (v) => email = v, 'email');
    field(() => password, (v) => password = v, 'password');
    field(() => state, (v) => state = v, 'state', enumValues: LoginState.values);
    field(() => date, (v) => date = v, 'date',
        instance: (data) => data != null ? anxeb.Utils.convert.fromTickToDate(data) : null);
  }

  LoginProvider provider;
  String email;
  String password;
  LoginState state;
  DateTime date;
}

enum LoginProvider { email, facebook, google, apple }

enum LoginState { active, inactive, unconfirmed, removed }
