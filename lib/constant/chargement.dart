import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Chargement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: SpinKitCubeGrid(
          color: Colors.blue[900],
          size: 50.0,
          duration: Duration(milliseconds: 400),
        )));
  }
}
