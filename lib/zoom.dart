import 'dart:io';

import 'package:flutter/material.dart';

class Zoom extends StatelessWidget {
  final data;
  Zoom({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('zoom'),
      ),
      body: Container(
        child: Image.file(File(data.toString())),
      ),
    );
  }
}
