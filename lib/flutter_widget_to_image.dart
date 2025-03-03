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
    //
    ///Retry counter
    ///
    int retryCounter = 3;
    bool isDirty = false;

    Widget child = widget;

    if (context != null) {
      ///
      ///Inherit Theme and MediaQuery of app
      ///
      ///
      child = InheritedTheme.captureAll(
        context,
        MediaQuery(
            data: MediaQuery.of(context),
            child: Material(
              child: child,
              color: Colors.transparent,
            )),
      );
    }

    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    final fallBackView = platformDispatcher.views.first;
    final view =
    context == null ? fallBackView : View.maybeOf(context) ?? fallBackView;
    Size logicalSize =
        targetSize ?? view.physicalSize / view.devicePixelRatio; // Adapted
    Size imageSize = targetSize ?? view.physicalSize; // Adapted

    assert(logicalSize.aspectRatio.toStringAsPrecision(5) ==
        imageSize.aspectRatio
            .toStringAsPrecision(5)); // Adapted (toPrecision was not available)

    final RenderView renderView = RenderView(
      view: view,
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        // size: logicalSize,
        logicalConstraints: BoxConstraints(
          maxWidth: logicalSize.width,
          maxHeight: logicalSize.height,
        ),
        devicePixelRatio: pixelRatio ?? 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(
        focusManager: FocusManager(),
        onBuildScheduled: () {
          ///
          ///current render is dirty, mark it.
          ///
          isDirty = true;
        });

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
    RenderObjectToWidgetAdapter<RenderBox>(
        container: repaintBoundary,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: child,
        )).attachToRenderTree(
      buildOwner,
    );
    ////
    ///Render Widget
    ///
    ///

    buildOwner.buildScope(
      rootElement,
    );
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image? image;

    do {
      ///
      ///Reset the dirty flag
      ///
      ///
      isDirty = false;

      image = await repaintBoundary.toImage(
          pixelRatio: pixelRatio ?? (imageSize.width / logicalSize.width));

      ///
      ///This delay sholud increas with Widget tree Size
      ///

      await Future.delayed(delay);

      ///
      ///Check does this require rebuild
      ///
      ///
      if (isDirty) {
        ///
        ///Previous capture has been updated, re-render again.
        ///
        ///
        buildOwner.buildScope(
          rootElement,
        );
        buildOwner.finalizeTree();
        pipelineOwner.flushLayout();
        pipelineOwner.flushCompositingBits();
        pipelineOwner.flushPaint();
      }
      retryCounter--;

      ///
      ///retry untill capture is successfull
      ///
    } while (isDirty && retryCounter >= 0);
    try {
      /// Dispose All widgets
      // rootElement.visitChildren((Element element) {
      //   rootElement.deactivateChild(element);
      // });
      buildOwner.finalizeTree();
    } catch (e) {}

    return image;
    // WidgetsFlutterBinding.ensureInitialized();
    // final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
    //
    // final PipelineOwner pipelineOwner = PipelineOwner();
    // final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    // try {
    //   final RenderView renderView = RenderView(
    //     window: ui.window,
    //     child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
    //     configuration: ViewConfiguration(
    //       size: Size(widthImage, 1000),
    //       devicePixelRatio: pixelRatio,
    //     ),
    //   );
    //
    //   pipelineOwner.rootNode = renderView;
    //   renderView.prepareInitialFrame();
    //   final MediaQueryData query = MediaQueryData.fromWindow(ui.window);
    //   final RenderObjectToWidgetElement<RenderBox> rootElement = RenderObjectToWidgetAdapter<RenderBox>(
    //     container: repaintBoundary,
    //     child: MediaQuery(
    //       data: query.copyWith(
    //         devicePixelRatio: pixelRatio,
    //         textScaleFactor: 1,
    //         boldText: false,
    //       ),
    //       child: Directionality(
    //         textDirection: TextDirection.ltr,
    //         child: widget,
    //       ),
    //     ),
    //   ).attachToRenderTree(buildOwner);
    //   buildOwner.buildScope(rootElement);
    //   buildOwner.finalizeTree();
    //   pipelineOwner.flushLayout();
    //   pipelineOwner.flushCompositingBits();
    //   pipelineOwner.flushPaint();
    //   final ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    //
    //   final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //
    //   var buff = byteData!.buffer.asUint8List();
    //
    //   var decodedImage = await decodeImageFromList(buff);
    //   print(decodedImage.width);
    //   print(decodedImage.height);
    //   return buff;
    // } catch (e) {
    //   print("___ $e");
    // }
    // return null;
  }
}
