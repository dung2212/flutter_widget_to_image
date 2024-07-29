library flutter_widget_to_image;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

class FlutterWidgetToImage {
  static Future<Uint8List?> captureFromWidget(
    Widget widget, {
    Duration delay = const Duration(seconds: 1),
    double pixelRatio = 1,
    BuildContext? context,
    required double widthImage,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    try {
      final RenderView renderView = RenderView(
        window: ui.window,
        child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
        configuration: ViewConfiguration(
          size: Size(widthImage, 1000),
          devicePixelRatio: pixelRatio,
        ),
      );

      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();
      final MediaQueryData query = MediaQueryData.fromWindow(ui.window);
      final RenderObjectToWidgetElement<RenderBox> rootElement = RenderObjectToWidgetAdapter<RenderBox>(
        container: repaintBoundary,
        child: MediaQuery(
          data: query.copyWith(
            devicePixelRatio: pixelRatio,
            textScaleFactor: 1,
            boldText: false,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          ),
        ),
      ).attachToRenderTree(buildOwner);
      buildOwner.buildScope(rootElement);
      buildOwner.finalizeTree();
      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();
      final ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);

      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      var buff = byteData!.buffer.asUint8List();

      var decodedImage = await decodeImageFromList(buff);
      print(decodedImage.width);
      print(decodedImage.height);
      return buff;
    } catch (e) {
      print("___ $e");
    }
    return null;
  }
}
