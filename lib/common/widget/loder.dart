import 'package:flutter/material.dart';

class Loder extends StatelessWidget {
  const Loder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
