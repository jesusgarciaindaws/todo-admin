import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/models/local/configuration.dart';
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/middleware/session.dart';

class Application extends anxeb.Application {
  Session _session;
  ConfigurationModel _configuration;
  bool _loaded;
  anxeb.Api _api;
  anxeb.PageMiddleware<Application, PageMeta> _middleware;

  Application() {
    _loaded = false;
  }

  @override
  void onMessage(anxeb.RemoteMessage message, anxeb.MessageEventType event) {}

  @override
  void onEvent(anxeb.ApplicationEventType type, {String reference, String description, dynamic data}) {}

  @override
  void init() {
    _session = Session(this);
    _configuration = ConfigurationModel.fromDisk();
    _middleware = anxeb.PageMiddleware<Application, PageMeta>(
      application: this,
      redirect: redirect,
    );

    _api = anxeb.Api(Global.settings.apiUrl, connectTimeout: 120000, receiveTimeout: 120000);
    title = 'Nodrix Access';

    var $appVersion = anxeb.Device?.info?.package?.version;
    var $buildNumber = anxeb.Device?.info?.package?.buildNumber;
    var $tz = DateTime.now().timeZoneOffset?.inMinutes;
    String $osType;
    String $osVersion;
    try {
      $osType = Platform?.operatingSystem;
    } catch (err) {
      //ignore
    }
    try {
      $osVersion = Platform?.version;
    } catch (err) {
      //ignore
    }

    _api.interceptors.add(
      anxeb.InterceptorsWrapper(
        onRequest: (anxeb.RequestOptions options, anxeb.RequestInterceptorHandler handler) {
          options.headers['accept-language'] = _configuration?.language ?? 'es';

          if ($tz != null) {
            options.headers['tz-offset'] = $tz;
          }
          if ($osType != null) {
            options.headers['device-os-type'] = $osType;
          }
          if ($osVersion != null) {
            options.headers['device-os-ver'] = $osVersion;
          }
          if ($appVersion != null) {
            options.headers['app-ver'] = $appVersion;
          }
          if ($buildNumber != null) {
            options.headers['app-rev'] = $buildNumber;
          }
          options.headers['app-code'] = Global.settings.codeName;

          return handler.next(options);
        },
        onResponse: (anxeb.Response e, anxeb.ResponseInterceptorHandler handler) {
          return handler.next(e);
        },
        onError: (anxeb.DioError e, anxeb.ErrorInterceptorHandler handler) {
          return handler.next(e);
        },
      ),
    );

    settings.analytics.available = false;

    settings.colors.primary = const Color(0xff0272E7);
    settings.colors.secudary = const Color(0xff0272E7);
    settings.colors.busybox = const Color(0xff0272E7);
    settings.colors.background = Colors.white;
    settings.colors.navigation = settings.colors.primary;
    settings.colors.link = const Color(0xff0272E7);
    settings.colors.input = const Color(0xfff6f6f6);

    settings.dialogs.buttonRadius = 12;
    settings.dialogs.dialogRadius = 20;
    settings.dialogs.buttonTextStyle = Global.styles.dialogButton;

    settings.panels.buttonRadius = 20;
    settings.overlay.brightness = Brightness.light;
    settings.dialogs.headerColor = const Color(0xfff6f6f6);

    settings.alerts.showFromBottom = () => true;

    settings.alerts.margin = () {
      final width = _middleware.scope.window.size.width;
      const pad = 40.0;
      if (_middleware.info.state.subloc == '/login') {
        return EdgeInsets.only(left: pad, bottom: 60, right: width - (width * (2 / 5)) + pad);
      }
      return null;
    };

    super.init();
  }

  Future<String> redirect<PageMeta>(BuildContext context, anxeb.GoRouterState state, anxeb.PageScope scope,
      [anxeb.PageInfo info]) async {
    if (state.subloc == '' || state.subloc == '/') {
      return '/login';
    } else if (scope == null || info == null || state.subloc == '/login' || info.meta?.roles?.contains('*') == true) {
      return null;
    }

    if (session.authenticated != true) {
      await scope.alerts
          .exception('Debe autenticar su usuario para acceder a este recurso', title: 'Acceso Denegado')
          .show();
      return '/login';
    }

    return null;
  }

  String getBackendUri(String uri) {
    return Global.settings.apiUrl + uri;
  }

  void unload() {
    _loaded = false;
  }

  @override
  Future setup({List<String> locales}) async {
    await super.setup(locales: locales);
    await configuration.loadFromDisk('configuration');
    final locale = localization?.supportedLocales
        ?.firstWhere((element) => element.languageCode == configuration.language, orElse: () => null);
    if (locale != null) {
      localization.changeLocale(locale);
    }
    await session.check();
    _loaded = true;
  }

  anxeb.PageMiddleware<Application, PageMeta> get middleware => _middleware;

  @override
  anxeb.Api get api => _api;

  Color get mainColor => settings.colors.primary;

  ConfigurationModel get configuration => _configuration;

  Session get session => _session;

  bool get loaded => _loaded;

  String get currentLocale => localization?.currentLocale?.languageCode ?? 'es';
}
