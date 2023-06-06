import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';

class BuildBlock extends StatelessWidget {
  final Application application;
  final Color fill;
  final String aboutPath;

  const BuildBlock({Key key, @required this.application, this.fill, this.aboutPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 18),
      decoration: BoxDecoration(
        color: fill,
        gradient: fill != null
            ? null
            : const LinearGradient(
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
                stops: [0, 1],
                colors: [
                  Colors.black12,
                  Colors.black54,
                ],
              ),
      ),
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            '© 2023 Nodrix. Todos los derechos reservados',
            style: TextStyle(
                fontSize: 12, color: Colors.white, decoration: TextDecoration.none, fontWeight: FontWeight.w300),
          ),
          const Text(' • ',
              style: TextStyle(
                  fontSize: 18, color: Colors.white, decoration: TextDecoration.none, fontWeight: FontWeight.w300)),
          anxeb.LinkButton(
            text: 'Acerca de Nodrix',
            color: Colors.white,
            style: const TextStyle(
                fontSize: 12, color: Colors.white, decoration: TextDecoration.none, fontWeight: FontWeight.w300),
            onPressed: () {
              context.go(aboutPath ?? '/about');
            },
          ),
          const Text(' • ',
              style: TextStyle(
                  fontSize: 18, color: Colors.white, decoration: TextDecoration.none, fontWeight: FontWeight.w300)),
          anxeb.LinkButton(
            text: 'nodrix.com',
            color: Colors.white,
            style: const TextStyle(
                fontSize: 12, color: Colors.white, decoration: TextDecoration.none, fontWeight: FontWeight.w300),
            onPressed: () {
              anxeb.Device.launchUrl(scope: application.middleware.scope, url: 'https://nodrix.com');
            },
          ),
          const Text(' • ',
              style: TextStyle(
                  fontSize: 18, color: Colors.white, decoration: TextDecoration.none, fontWeight: FontWeight.w300)),
          Text(
            'build v${application?.info?.package?.version}',
            style: const TextStyle(
                fontSize: 12, color: Colors.white, decoration: TextDecoration.none, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
