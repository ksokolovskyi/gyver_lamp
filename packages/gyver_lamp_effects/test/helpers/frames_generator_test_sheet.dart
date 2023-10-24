import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/widgets/widgets.dart';

const _kFramesInRow = 8;

class FramesGeneratorTestSheet extends StatefulWidget {
  const FramesGeneratorTestSheet({
    required this.generator,
    required this.speed,
    required this.scale,
    super.key,
  });

  final FramesGenerator generator;

  final int speed;

  final int scale;

  @override
  State<FramesGeneratorTestSheet> createState() =>
      _FramesGeneratorTestSheetState();
}

class _FramesGeneratorTestSheetState extends State<FramesGeneratorTestSheet> {
  @override
  Widget build(BuildContext context) {
    final generator = widget.generator..reset();

    final dimension = MediaQuery.sizeOf(context).shortestSide / _kFramesInRow;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: GridView.count(
        crossAxisCount: _kFramesInRow,
        children: [
          for (var i = 0; i < _kFramesInRow * _kFramesInRow; i++)
            SizedBox.square(
              dimension: dimension,
              child: FramePainter(
                frame: generator.generate(
                  speed: widget.speed,
                  scale: widget.scale,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
