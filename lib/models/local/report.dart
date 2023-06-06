import 'dart:convert';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;

class ReportModel extends anxeb.Model<ReportModel> {
  ReportModel([data]) : super(data);

  @override
  void init() {
    field(() => group, (v) => group = v, 'group');
    field(() => name, (v) => name = v, 'name');
    field(() => caption, (v) => caption = v, 'caption');
    field(() => attachment, (v) => attachment = v, 'attachment');
    field(() => template, (v) => template = v, 'template');
    field(() => content, (v) => content = v, 'content');
    field(() => rebuild, (v) => rebuild = v, 'rebuild');
    field(() => download, (v) => download = v, 'download');
    field(() => format, (v) => format = v, 'format');
  }

  String group;
  String name;
  String caption;
  String attachment;
  String template;
  String content;
  bool rebuild;
  bool download;
  String format;

  String get filename => '$name.pdf';

  dynamic getData({bool download, bool rebuild}) {
    var params = super.toObjects();
    if (download != null) {
      params['download'] = download;
    }
    if (rebuild != null) {
      params['rebuild'] = rebuild;
    }
    return params;
  }

  String url({bool download, bool rebuild}) {
    var params = getData(download: download, rebuild: rebuild);
    var query = base64.encode(utf8.encode(json.encode(params)));
    return '/report?data=$query';
  }
}
