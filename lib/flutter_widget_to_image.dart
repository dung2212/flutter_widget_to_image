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
    try {
      // 1. Tạo RepaintBoundary để render widget
      final RenderRepaintBoundary boundary = RenderRepaintBoundary();

      // 2. Tạo một RenderView mới trong bộ nhớ
      final PipelineOwner pipelineOwner = PipelineOwner();
      final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
      final RenderView renderView = RenderView(
        child: RenderPositionedBox(alignment: Alignment.center, child: boundary),
        configuration: ViewConfiguration(
            logicalConstraints: BoxConstraints(
              maxWidth: widthImage,
              maxHeight: 10000,
            ),
            devicePixelRatio: pixelRatio),
        view: WidgetsBinding.instance.platformDispatcher.views.first, // Cập nhật cho Flutter 3.27.x
      );

      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();

      final MediaQueryData query = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first);
      // 3. Attach widget vào RenderObject
      final RenderObjectToWidgetElement<RenderBox> element = RenderObjectToWidgetAdapter<RenderBox>(
        container: boundary,
        child: MediaQuery(
          data: query.copyWith(
            devicePixelRatio: pixelRatio,
            textScaler: TextScaler.linear(1),
            boldText: false,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          ),
        ),
      ).attachToRenderTree(buildOwner);

      // 4. Xây dựng và vẽ widget
      buildOwner.buildScope(element);
      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();

      // 5. Chuyển thành ảnh Uint8List
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (ex) {}
    return null;
  }
}
