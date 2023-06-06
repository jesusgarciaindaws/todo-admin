import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  final String header;
  final Widget body;

  const Panel({Key key, this.header, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const double size = 600;

    return SizedBox(
      width: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(15),
            child: Text(
              header,
              style: textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: body,
          )
        ],
      ),
    );
  }
}
