import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/helpers/reference.dart';
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/global.dart';

class ReferenceModel extends anxeb.HelpedModel<ReferenceModel, ReferenceHelper> {
  ReferenceModel([data]) : super(data);

  @override
  void init() {
    field(() => id, (v) => id = v, has('_id') ? '_id' : 'id', primary: true);
    field(() => name, (v) => name = v, 'name');
    field(() => type, (v) => type = v, 'type', enumValues: ReferenceType.values);
    field(() => parent, (v) => parent = v, 'parent', instance: (data) => ReferenceModel(data));
    field(() => root, (v) => root = v, 'root', instance: (data) => ReferenceModel(data));
    field(() => childs, (v) => childs = v, 'childs',
        defect: () => <ReferenceModel>[], instance: (data) => ReferenceModel(data));
  }

  String id;
  String name;
  ReferenceType type;
  ReferenceModel parent;
  ReferenceModel root;
  List<ReferenceModel> childs;

  ReferenceType get childType {
    const parentToChild = {
      ReferenceType.country: ReferenceType.country_state,
      ReferenceType.country_state: ReferenceType.state_city,
      ReferenceType.state_city: null,
    };
    return type != null ? parentToChild[type] : type;
  }

  ReferenceType get finalType => parent?.childType ?? type;

  @override
  ReferenceHelper helper() => ReferenceHelper();

  @override
  String toString() => root?.name != null ? '${root.name}: $name' : name;

  static Future<T> lookupLeaf<T extends ReferenceModel>({
    anxeb.Scope scope,
    ReferenceType type,
    IconData icon,
    String dialogTitle,
    String rootTitle,
    T Function(dynamic data) instance,
    ReferenceType leaf,
  }) async {
    final result = await lookupBranch(
      scope: scope,
      type: type,
      icon: icon,
      dialogTitle: dialogTitle,
      rootTitle: rootTitle,
      instance: instance,
      leaf: leaf,
    );
    return result?.isNotEmpty == true ? result.last : null;
  }

  static Future<List<T>> lookupBranch<T extends ReferenceModel>({
    anxeb.Scope scope,
    ReferenceType type,
    IconData icon,
    String dialogTitle,
    String emptyTitle,
    String rootTitle,
    T Function(dynamic data) instance,
    ReferenceType leaf,
  }) async {
    final application = scope.application as Application;

    $addNew(anxeb.ReferencerPage<T> page) async {
      final reference = ReferenceModel();
      final parent = page?.parent?.selected;

      reference.root = parent?.root?.id != null ? parent?.root : null;
      if (parent?.id != null) {
        reference.parent = parent;
      } else {
        reference.type = type;
      }

      final result = await reference.using(scope).edit(success: (helper) async => true, persist: true);

      if (result != null) {
        page.refresh();
      }
    }

    final typeString = type.toString().split('.')[1];
    final result = await scope.dialogs
        .referencer<T>(dialogTitle,
            icon: icon,
            width: Global.settings.smallFormWidth,
            height: scope.window.vertical(0.5),
            loader: (page, [ReferenceModel parent]) async {
              final $reference = parent;
              if (leaf != null && $reference?.type == leaf) {
                return null;
              }
              String uri;
              if (parent != null) {
                uri = '/references?parent=${$reference.id}';
              } else {
                uri = '/references?type=$typeString';
              }

              final data = await scope.api.get(uri);
              if (data.length == 0) {
                //return null;
              }
              return data.list<T>((e) => instance(e));
            },
            comparer: (a, b) => a == b,
            headerWidget: ($page) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: scope.application.settings.colors.separator,
                          ),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            $page?.parent?.selected?.name ?? rootTitle,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, color: scope.application.settings.colors.secudary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemWidget: ($page, $reference) {
              final isSelected = $page.isSelected($reference);
              return anxeb.ListTitleBlock(
                scope: scope,
                iconTrail: Icons.keyboard_arrow_right,
                iconTrailScale: 0.4,
                busy: $page.isBusy($reference),
                iconScale: 0.6,
                titleStyle: TextStyle(
                    color: isSelected ? scope.application.settings.colors.active : Colors.white,
                    fontSize: 16,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w300),
                iconTrailColor: Colors.white,
                fillColor:
                    isSelected ? scope.application.settings.colors.secudary : scope.application.settings.colors.primary,
                margin: const EdgeInsets.symmetric(vertical: 3),
                iconColor: scope.application.settings.colors.secudary,
                title: $reference.name,
                onTap: () async {
                  if ($page.idle) {
                    try {
                      await $page.select($reference);
                    } catch (err) {
                      //ignore
                    }
                  }
                },
                padding: const EdgeInsets.only(left: 12, top: 5, bottom: 5, right: 5),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              );
            },
            createWidget: (anxeb.ReferencerPage<T> $page) {
              return anxeb.ListTitleBlock(
                scope: scope,
                iconTrail: Icons.add,
                iconTrailScale: 0.4,
                busy: false,
                iconScale: 0.6,
                titleStyle:
                    const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 0, fontWeight: FontWeight.w300),
                iconTrailColor: Colors.white,
                fillColor: scope.application.settings.colors.success,
                margin: const EdgeInsets.symmetric(vertical: 3),
                iconColor: scope.application.settings.colors.secudary,
                title:
                    'Agregar ${Global.captions.referenceType($page.parent?.selected?.childType ?? type) ?? 'Elemento'}',
                onTap: () async {
                  $addNew($page);
                },
                padding: const EdgeInsets.only(left: 12, top: 5, bottom: 5, right: 5),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              );
            },
            emptyWidget: ($page) {
              return anxeb.EmptyBlock(
                scope: scope,
                message: emptyTitle ??
                    'No existen ${Global.captions.referenceType($page.parent?.selected?.childType ?? type, plural: true).toLowerCase() ?? 'elementos'}${$page?.parent?.selected == null ? '\nen el regsitro' : ' para\n${$page?.parent?.selected?.name}'}',
                icon: anxeb.Octicons.info,
                iconScale: 0.8,
                tight: true,
                actionText: application.session.canAddReferences ? 'Agregar' : 'Refrescar',
                actionCallback: () async => application.session.canAddReferences ? $addNew($page) : $page.refresh(),
              );
            })
        .show();
    return result;
  }
}

enum ReferenceType { country, country_state, state_city }
