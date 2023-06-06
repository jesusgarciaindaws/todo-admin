import 'package:todo_admin/global/captions.dart';
import 'package:todo_admin/global/colors.dart';
import 'package:todo_admin/global/faddings.dart';
import 'package:todo_admin/global/gradients.dart';
import 'package:todo_admin/global/icons.dart';
import 'package:todo_admin/global/margins.dart';
import 'package:todo_admin/global/paddings.dart';
import 'package:todo_admin/global/settings.dart';
import 'package:todo_admin/global/shadows.dart';
import 'package:todo_admin/global/styles.dart';
import 'package:todo_admin/global/themes.dart';

class Global {
  static final Global _singleton = Global._internal(const bool.fromEnvironment('dart.vm.product'));
  static GlobalColors colors = GlobalColors();
  static GlobalStyles styles = GlobalStyles();
  static GlobalPaddings paddings = GlobalPaddings();
  static GlobalMargins margins = GlobalMargins();
  static GlobalFaddings faddings = GlobalFaddings();
  static GlobalGradients gradients = GlobalGradients();
  static GlobalSettings settings = GlobalSettings(
    const String.fromEnvironment('mode'),
  );
  static GlobalShadows shadows = GlobalShadows();
  static GlobalCaptions captions = GlobalCaptions();
  static GlobalIcons icons = GlobalIcons();
  static GlobalThemes themes = GlobalThemes();

  factory Global() {
    return _singleton;
  }

  Global._internal(bool production);
}
