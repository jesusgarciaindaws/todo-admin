import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/models/primary/reference.dart';

class CountryReference extends ReferenceModel {
  CountryReference([data]) : super(data);

  static Future<CountryReference> lookup({anxeb.Scope scope, IconData icon, String title}) async {
    return ReferenceModel.lookupLeaf<CountryReference>(
      scope: scope,
      type: ReferenceType.country,
      icon: icon ?? Icons.location_on,
      dialogTitle: title ?? 'Localidad',
      leaf: ReferenceType.country,
      rootTitle: 'País',
      instance: (data) => CountryReference(data),
    );
  }
}
