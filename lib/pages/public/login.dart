import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/middleware/session.dart';
import 'package:todo_admin/models/local/credentials.dart';
import 'package:todo_admin/widgets/blocks/text_button.dart';
import 'package:todo_admin/widgets/blocks/title.dart';

class LoginPage extends anxeb.PageWidget<Application, PageMeta> {
  LoginPage({Key key}) : super('login', key: key, path: 'login');

  @override
  createState() => _LoginState();
}

class _LoginState extends anxeb.PageView<LoginPage, Application, PageMeta> {
  final ImageProvider _brandVertical = const AssetImage('assets/images/brand/color-vertical.png');
  final ImageProvider _brandHorizontal = const AssetImage('assets/images/brand/color-horizontal.png');
  final ImageProvider _background = const AssetImage('assets/images/common/login-background.jpeg');
  bool _tokenized;

  @override
  void initState() {
    super.initState();
  }

  @override
  // TODO: implement title
  String get title => anxeb.translate('pages.public.about.title');

  @override
  void setup() async {
    session.check();

    await Future.wait(
        [_brandHorizontal, _brandVertical, _background].map((element) async => await precacheImage(element, context)));

    _tokenized = application.configuration.tokenized;
    rasterize();
  }

  @override
  void prebuild() {}

  @override
  Future<bool> beforePop() async => true;

  @override
  Widget content() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.screen),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          image: _background,
        ),
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          stops: const [0, 1],
          colors: [
            const Color(0xffffffff).withOpacity(0.0),
            const Color(0xfff1f1f1).withOpacity(0.5),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(bottom: 80),
              alignment: Alignment.center,
              color: Colors.white.withOpacity(0.2),
              child: SizedBox(
                width: 360,
                /*padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.only(bottom: 120),
                decoration: BoxDecoration(
                  color: settings.colors.background,
                  borderRadius: BorderRadius.circular(12),
                ),*/
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20, right: 20, bottom: 50),
                      child: Image(
                        image: _brandVertical,
                        width: 200,
                      ),
                    ),
                    anxeb.TextInputField(
                      scope: scope,
                      theme: Global.themes.loginFields,
                      name: 'email',
                      group: 'login',
                      icon: Icons.email,
                      label: 'Correo',
                      margin: Global.margins.field,
                      fetcher: () => application?.configuration?.auth?.user?.login?.email,
                      type: anxeb.TextInputFieldType.email,
                      validator: anxeb.Utils.validators.email,
                      action: TextInputAction.next,
                      selected: true,
                      autofocus: true,
                    ),
                    anxeb.TextInputField(
                      scope: scope,
                      theme: Global.themes.loginFields,
                      name: 'password',
                      group: 'login',
                      icon: Icons.lock,
                      label: 'Contraseña',
                      type: anxeb.TextInputFieldType.password,
                      validator: anxeb.Utils.validators.password,
                      action: TextInputAction.go,
                      onActionSubmit: (val) => _login(),
                    ),
                    TextButtonBlock(
                      scope: scope,
                      margin: Global.margins.button,
                      text: 'Iniciar Sesión',
                      onPressed: _login,
                    ),
                    _tokenized == true
                        ? Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 18, top: 18),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: anxeb.DottedLine(
                                        direction: Axis.horizontal,
                                        lineLength: double.infinity,
                                        lineThickness: 0.5,
                                        dashColor: Colors.black.withOpacity(0.8),
                                        dashGapLength: 0,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: const Text('también puede'),
                                    ),
                                    Expanded(
                                      child: anxeb.DottedLine(
                                        direction: Axis.horizontal,
                                        lineLength: double.infinity,
                                        lineThickness: 0.5,
                                        dashColor: Colors.black.withOpacity(0.8),
                                        dashGapLength: 0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButtonBlock(
                                      scope: scope,
                                      text: 'Continuar como ${application.configuration.auth.user.firstNames}',
                                      onPressed: _continue,
                                      fill: application.settings.colors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              color: Colors.white.withOpacity(0.5),
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.red,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
                        child: const TitleBlock(
                          text: 'Administración de tareas',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  void _continue() async {
    await scope.busy();
    try {
      final auth = await session.open();
      if (auth != null) {
        go('/home');
      }
    } catch (err) {
      scope.alerts.error(err).show();
      await session.close();
      scope.forms.current.fields['email'].focus();
    } finally {
      await scope.idle();
    }
  }

  void _login() async {
    if (session.closed && scope.forms.valid()) {
      await scope.busy();
      final credentials = CredentialsModel(scope.forms.data());
      try {
        final auth = await session.open(credentials);

        if (auth != null) {
          await scope.alerts.success('Hola ${session.user.toString()}!', delay: 500).show();
          go('/home');
        }
      } catch (err) {
        scope.alerts.error(err).show();
        scope.forms.current.fields['password'].focus();
      } finally {
        await scope.idle();
      }
    }
  }

  Session get session => application.session;
}
