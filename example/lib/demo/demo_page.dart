import 'package:flutter/material.dart';
import 'package:flutter_widget_to_image_example/demo/demo_view.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Column(
        children: [
          const DemoView(),
          const SizedBox(height: 30),
          MediaQuery(
            data: query.copyWith(
              size: const Size(300, 300),
              devicePixelRatio: 2,
              textScaleFactor: 1,
              boldText: false,
              disableAnimations: true,
            ),
            child: DemoView(),
          ),
        ],
      ),
    );
  }
}
