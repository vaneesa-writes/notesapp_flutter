import 'dart:io';

import 'package:flutter/material.dart';

class fullimage extends StatefulWidget {
  final String path;
  const fullimage(this.path, {Key? key}) : super(key: key);

  @override
  State<fullimage> createState() => _fullimageState();
}

class _fullimageState extends State<fullimage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: FileImage(File(widget.path)),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
