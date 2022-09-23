import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  Loader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 300.0,
      height: 300.0,
      child: new Padding(
          padding: const EdgeInsets.all(5.0),
          child: new Center(child: new CircularProgressIndicator())),
    );
  }
}
