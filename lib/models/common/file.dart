import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/global.dart';

class FileModel extends anxeb.Model<FileModel> {
  FileModel([data]) : super(data);

  String id;
  String title;
  String extension;

  @override
  void init() {
    field(() => id, (v) => id = v, 'id', primary: true);
    field(() => title, (v) => title = v, 'title');
    field(() => extension, (v) => extension = v, 'extension');
  }

  anxeb.FileInputValue toFileInputValue() {
    return anxeb.FileInputValue(
      url: '${Global.settings.apiUrl}/files/$id',
      extension: extension.replaceAll('.', ''),
      title: title,
    );
  }
}
