import 'package:flutter/material.dart';
import 'package:flutter_widget_to_image/flutter_widget_to_image.dart';
import 'package:flutter_widget_to_image_example/demo/demo_view.dart';
import 'package:flutter_widget_to_image_example/show_image/show_image_page.dart';

import '../demo/demo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _shot() async {
    var image = await FlutterWidgetToImage.captureFromWidget(const DemoView(), widthImage: 200, pixelRatio: 1);
    var image2 = await FlutterWidgetToImage.captureFromWidget(const DemoView(), widthImage: 200, pixelRatio: 1);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowImagePage(
          image: image!,
          image2: image2!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DemoPage(),
                  ),
                );
              },
              child: Text("Show Demo"),
            ),
            ElevatedButton(
              onPressed: () {
                _shot();
              },
              child: Text("Shot"),
            ),
          ],
        ),
      ),
    );
  }
}
