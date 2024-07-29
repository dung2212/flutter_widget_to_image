import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowImagePage extends StatefulWidget {
  final Uint8List image;
  final Uint8List image2;

  const ShowImagePage({Key? key, required this.image, required this.image2}) : super(key: key);

  @override
  State<ShowImagePage> createState() => _ShowImagePageState();
}

class _ShowImagePageState extends State<ShowImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Column(
        children: [
          Image.memory(widget.image),
          Image.memory(widget.image2),
        ],
      ),
    );
  }
}
