import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/global.dart';


class IdentityModel extends anxeb.Model<IdentityModel> {
  IdentityModel([data]) : super(data);

  @override
  void init() {
    field(() => type, (v) => type = v, 'type', enumValues: IdentityType.values);
    field(() => number, (v) => number = v, 'number');
  }

  @override
  String toString() {
    if (type == null || number == null) {
      return null;
    }
    return '${Global.captions.identityType(type)}: $number';
  }

  IdentityType type;
  String number;
}

enum IdentityType { passport, license, personal, company }
