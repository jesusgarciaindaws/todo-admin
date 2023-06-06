import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'containers/private.dart';
import 'containers/public.dart';
import 'middleware/application.dart';
import 'middleware/page_meta.dart';
import 'pages/common/error.dart';

void main() async {
  final application = Application();
  await application.setup(locales: ['es', 'en']);

  runApp(anxeb.EntryPage<Application, PageMeta>(
    middleware: application.middleware,
    errorPage: () => ErrorPage(),
    title: 'Nodrix',
    containers: [
      () => PublicContainer(),
      () => PrivateContainer(),
    ],
    theme: ThemeData(
      primaryColor: application.settings.colors.primary,
      colorScheme: ColorScheme.light(
        primary: application.settings.colors.primary,
        secondary: application.settings.colors.secudary,
        secondaryContainer: application.settings.colors.primary,
        onSecondary: Colors.white,
        background: Colors.yellow,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 22,
        ),
        actionsIconTheme: IconThemeData(
          color: application.settings.colors.primary,
        ),
        iconTheme: IconThemeData(
          color: application.settings.colors.primary,
        ),
        toolbarTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: application.settings.colors.primary,
        ),
      ),
      dialogTheme: const DialogTheme(),
      primaryIconTheme: const IconThemeData(color: Colors.white),
    ),
  ));
}
