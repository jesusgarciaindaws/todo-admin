import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'auth.dart';

class ConfigurationModel extends anxeb.Model<ConfigurationModel> {
  ConfigurationModel([data]) : super(data);

  ConfigurationModel.fromDisk([anxeb.ModelLoadedCallback<ConfigurationModel> callback])
      : super.fromDisk('configuration', callback);

  bool get isAuthSaved => auth?.user?.login?.email?.isNotEmpty == true;

  @override
  void init() {
    field(() => auth, (v) => auth = v, 'auth', instance: (data) => data != null ? SessionAuth(data) : null);
    field(() => language, (v) => language = v, 'language', defect: () => 'es');
  }

  bool get tokenized => auth?.token != null;

  SessionAuth auth;
  String language;
}
