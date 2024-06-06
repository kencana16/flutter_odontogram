library odontogram;

import 'package:flutter/material.dart';

import 'tooth_painter.dart';

class Odontogram extends StatelessWidget {
  const Odontogram({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...Tooth.toothQuadrant1Permanent.map((int e) => Tooth(
                  e,
                )),
            const SizedBox(width: 50),
            ...Tooth.toothQuadrant2Permanent.map((int e) => Tooth(e)),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...Tooth.toothQuadrant1Primary.map((int e) => Tooth(e)),
            const SizedBox(width: 50),
            ...Tooth.toothQuadrant2Primary.map((int e) => Tooth(e)),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...Tooth.toothQuadrant1Primary.map((int e) => Tooth(e)),
            const SizedBox(width: 50),
            ...Tooth.toothQuadrant2Primary.map((int e) => Tooth(e)),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...Tooth.toothQuadrant3Permanent.map((int e) => Tooth(e)),
            const SizedBox(width: 50),
            ...Tooth.toothQuadrant4Permanent.map((int e) => Tooth(e)),
          ],
        ),
      ],
    );
  }
}

class Tooth extends StatefulWidget {
  static const Set<int> toothQuadrant1 = {
    ...toothQuadrant1Permanent,
    ...toothQuadrant1Primary,
  };
  static const Set<int> toothQuadrant1Permanent = {
    18, 17, 16, 15, 14, 13, 12, 11, // Permanent teeth
  };
  static const Set<int> toothQuadrant1Primary = {
    55, 54, 53, 52, 51, // Primary teeth
  };

  static const Set<int> toothQuadrant2 = {
    ...toothQuadrant2Permanent,
    ...toothQuadrant2Primary,
  };
  static const Set<int> toothQuadrant2Permanent = {
    21, 22, 23, 24, 25, 26, 27, 28, // Permanent teeth
  };
  static const Set<int> toothQuadrant2Primary = {
    61, 62, 63, 64, 65, // Primary teeth
  };

  static const Set<int> toothQuadrant3 = {
    ...toothQuadrant3Permanent,
    ...toothQuadrant3Primary,
  };
  static const Set<int> toothQuadrant3Permanent = {
    38, 37, 36, 35, 34, 33, 32, 31, // Permanent teeth
  };
  static const Set<int> toothQuadrant3Primary = {
    75, 74, 73, 72, 71, // Primary teeth
  };

  static const Set<int> toothQuadrant4 = {
    ...toothQuadrant4Permanent,
    ...toothQuadrant4Primary,
  };
  static const Set<int> toothQuadrant4Permanent = {
    41, 42, 43, 44, 45, 46, 47, 48, // Permanent teeth
  };
  static const Set<int> toothQuadrant4Primary = {
    81, 82, 83, 84, 85, // Primary teeth
  };

  static const Set<int> validToothIndices = {
    ...toothQuadrant1,
    ...toothQuadrant2,
    ...toothQuadrant3,
    ...toothQuadrant4,
  };

  final int index;

  Tooth(this.index, {super.key})
      : assert(Tooth.validToothIndices.contains(index), 'Invalid tooth index');

  @override
  ToothState createState() => ToothState();
}

class ToothState extends State<Tooth> {
  Offset? hoverPosition;
  Offset? onTapUpPosition;
  int get index => widget.index;

  Set<ToothSurface> surfaces = {};

  @override
  Widget build(BuildContext context) {
    int firstIndex = int.parse(index.toString()[0]);
    ToothPainter painter = ToothPainter.adaptive(
      index,
      hoverPosition: hoverPosition,
      isCaries: surfaces.isNotEmpty,
      toothSurfaces: surfaces,
    );

    return Column(
      children: [
        if ([1, 2, 5, 6].contains(firstIndex))
          Text(index.toString())
        else
          SizedBox(height: 24),
        GestureDetector(
          onTapUp: (details) {
            var surface = painter.hoveredSurface;
            if (surface != null) {
              setState(() {
                if (surfaces.contains(surface)) {
                  surfaces.remove(surface);
                } else {
                  surfaces.add(surface);
                }
              });
            }
          },
          child: MouseRegion(
            onExit: (_) {
              setState(() {
                hoverPosition = null;
                print("$index  onExit${_.localPosition}");
              });
            },
            onHover: (details) {
              setState(() {
                hoverPosition = details.localPosition;
                print("$index ${hoverPosition}");
              });
            },
            child: CustomPaint(
              isComplex: true,
              painter: painter,
              size: const Size(56, 56),
            ),
          ),
        ),
        if ([3, 4, 7, 8].contains(firstIndex))
          Text(index.toString())
        else
          SizedBox(height: 24),
      ],
    );
  }
}

enum ToothSurface {
  M,
  O,
  D,
  V,
  L,
}
