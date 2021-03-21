import 'package:flutter/material.dart';

class LoadingFirstScreen extends StatelessWidget {
  LoadingFirstScreen({
    Key key,
    @required this.future,
    @required this.body,
  }) : super(key: key);

  final Future future;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            return body;
          default:
            return Container();
        }
      },
    );
  }
}
