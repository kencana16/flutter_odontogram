import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:odontogram/odontogram.dart';

class FrontToothPainter extends ToothPainter {
  FrontToothPainter(
    super.toothIndex, {
    super.hoverPosition,
    super.isCaries,
    super.toothSurfaces,
  });

  @override
  Path left(Size size) => Path()
    ..moveTo(size.width * 0.0, size.height * 0.0)
    ..lineTo(size.width * 0.33, size.height * 0.4)
    ..lineTo(size.width * 0.0, size.height * 0.99)
    ..close();

  @override
  Path top(Size size) => Path()
    ..moveTo(size.width * 0.0, size.height * 0.0)
    ..lineTo(size.width * 0.33, size.height * 0.4)
    ..lineTo(size.width * 0.66, size.height * 0.4)
    ..lineTo(size.width * 0.99, size.height * 0.00)
    ..close();

  @override
  Path right(Size size) => Path()
    ..moveTo(size.width * 0.99, size.height * 0.00)
    ..lineTo(size.width * 0.66, size.height * 0.4)
    ..lineTo(size.width * 0.99, size.height * 0.99)
    ..close();

  @override
  Path bottom(Size size) => Path()
    ..moveTo(size.width * 0.0, size.height * 0.99)
    ..lineTo(size.width * 0.33, size.height * 0.4)
    ..lineTo(size.width * 0.66, size.height * 0.4)
    ..lineTo(size.width * 0.99, size.height * 0.99)
    ..close();

  @override
  Path middle(Size size) => Path()
    ..moveTo(0, 0)
    ..close();
}

class ToothPainter extends CustomPainter {
  Map<ToothSurface, Path> basePaths;
  final int toothIndex;
  Offset? hoverPosition;
  final bool? isCaries;
  final Set<ToothSurface>? toothSurfaces;

  ToothPainter(
    this.toothIndex, {
    this.hoverPosition,
    this.isCaries,
    this.toothSurfaces,
  }) : basePaths = {};

  ToothSurface? get hoveredSurface {
    var hoverPosition = this.hoverPosition;
    for (var element in basePaths.entries) {
      if (hoverPosition != null && element.value.contains(hoverPosition)) {
        return element.key;
      }
    }
    return null;
  }

  factory ToothPainter.adaptive(
    int toothIndex, {
    Offset? hoverPosition,
    bool? isCaries,
    Set<ToothSurface>? toothSurfaces,
  }) {
    try {
      int secondIndex = int.parse(toothIndex.toString()[1]);
      if (secondIndex <= 3) {
        return FrontToothPainter(
          toothIndex,
          hoverPosition: hoverPosition,
        isCaries: isCaries,
        toothSurfaces: toothSurfaces,
        );
      }
    } catch (e) {
      log(e.toString());
    }
    return ToothPainter(toothIndex,
        hoverPosition: hoverPosition,
        isCaries: isCaries,
        toothSurfaces: toothSurfaces,);
  }

  @override
  void paint(Canvas canvas, Size size) {
    basePaths = generateBasePath(size);

    final hoverPosition = this.hoverPosition;
    basePaths.forEach((surface, path) {
      drawPath(
        canvas: canvas,
        path: path,
        surface: surface,
        hoverPosition: hoverPosition,
      );
    });
  }

  void drawPath({
    required Canvas canvas,
    required Path path,
    required ToothSurface? surface,
    required Offset? hoverPosition,
  }) {
    var toothSurfaces = this.toothSurfaces;
    if (isCaries == true &&
        surface != null &&
        (toothSurfaces?.contains(surface) ?? true)) {
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.grey,
      );
    }

    var basePathPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;
    if (hoverPosition != null && path.contains(hoverPosition)) {
      basePathPaint = basePathPaint
        ..strokeWidth = 2.0
        ..color = Colors.black;
    }
    canvas.drawPath(
      path,
      basePathPaint,
    );
  }

  Map<ToothSurface, Path> generateBasePath(Size size) {
    Map<ToothSurface, Path> paths = {};
    final quadrant = getToothQuadrant(toothIndex);

    switch (quadrant) {
      case 1:
        paths[ToothSurface.O] = middle(size);
        paths[ToothSurface.M] = right(size);
        paths[ToothSurface.D] = left(size);
        paths[ToothSurface.V] = top(size);
        paths[ToothSurface.L] = bottom(size);
        break;
      case 2:
        paths[ToothSurface.O] = middle(size);
        paths[ToothSurface.M] = left(size);
        paths[ToothSurface.D] = right(size);
        paths[ToothSurface.V] = top(size);
        paths[ToothSurface.L] = bottom(size);
        break;
      case 3:
        paths[ToothSurface.O] = middle(size);
        paths[ToothSurface.M] = left(size);
        paths[ToothSurface.D] = right(size);
        paths[ToothSurface.V] = bottom(size);
        paths[ToothSurface.L] = top(size);
        break;
      case 4:
        paths[ToothSurface.O] = middle(size);
        paths[ToothSurface.M] = right(size);
        paths[ToothSurface.D] = left(size);
        paths[ToothSurface.V] = bottom(size);
        paths[ToothSurface.L] = top(size);
        break;
      default:
        throw Exception('Invalid quadrant');
    }
    return paths;
  }

  int getToothQuadrant(int index) {
    if (Tooth.toothQuadrant1.contains(index)) {
      return 1;
    } else if (Tooth.toothQuadrant2.contains(index)) {
      return 2;
    } else if (Tooth.toothQuadrant3.contains(index)) {
      return 3;
    } else if (Tooth.toothQuadrant4.contains(index)) {
      return 4;
    } else {
      throw Exception('Invalid tooth index');
    }
  }

  Path left(Size size) => Path()
    ..moveTo(size.width * 0.0, size.height * 0.0)
    ..lineTo(size.width * 0.33, size.height * 0.33)
    ..lineTo(size.width * 0.33, size.height * 0.66)
    ..lineTo(size.width * 0.0, size.height * 0.99)
    ..close();

  Path top(Size size) => Path()
    ..moveTo(size.width * 0.0, size.height * 0.0)
    ..lineTo(size.width * 0.33, size.height * 0.33)
    ..lineTo(size.width * 0.66, size.height * 0.33)
    ..lineTo(size.width * 0.99, size.height * 0.00)
    ..close();

  Path right(Size size) => Path()
    ..moveTo(size.width * 0.99, size.height * 0.00)
    ..lineTo(size.width * 0.66, size.height * 0.33)
    ..lineTo(size.width * 0.66, size.height * 0.66)
    ..lineTo(size.width * 0.99, size.height * 0.99)
    ..close();

  Path bottom(Size size) => Path()
    ..moveTo(size.width * 0.0, size.height * 0.99)
    ..lineTo(size.width * 0.33, size.height * 0.66)
    ..lineTo(size.width * 0.66, size.height * 0.66)
    ..lineTo(size.width * 0.99, size.height * 0.99)
    ..close();

  Path middle(Size size) => Path()
    ..moveTo(size.width * 0.33, size.height * 0.33)
    ..lineTo(size.width * 0.66, size.height * 0.33)
    ..lineTo(size.width * 0.66, size.height * 0.66)
    ..lineTo(size.width * 0.33, size.height * 0.66)
    ..close();

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ToothPainter) {
      return (toothIndex != oldDelegate.toothIndex ||
          hoverPosition != oldDelegate.hoverPosition);
    }
    return true; // Always repaint to handle hover state changes
  }
}
