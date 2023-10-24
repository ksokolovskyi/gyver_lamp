import 'package:flutter_test/flutter_test.dart';

class GeneratorSettings {
  const GeneratorSettings({
    required this.dimension,
    required this.speed,
    required this.scale,
  });

  final int dimension;

  final int speed;

  final int scale;

  @override
  String toString() {
    return 'Dimension: $dimension, Speed: $speed, Scale $scale';
  }

  String get id => 'd${dimension}sp${speed}sc$scale';
}

class GeneratorSettingsVariant extends ValueVariant<GeneratorSettings> {
  GeneratorSettingsVariant(super.values);

  GeneratorSettingsVariant.all()
      : super(
          const {
            GeneratorSettings(dimension: 16, speed: 8, scale: 1),
            GeneratorSettings(dimension: 16, speed: 8, scale: 32),
            GeneratorSettings(dimension: 16, speed: 8, scale: 64),
            GeneratorSettings(dimension: 16, speed: 8, scale: 128),
            GeneratorSettings(dimension: 16, speed: 8, scale: 255),
            GeneratorSettings(dimension: 16, speed: 32, scale: 1),
            GeneratorSettings(dimension: 16, speed: 32, scale: 32),
            GeneratorSettings(dimension: 16, speed: 32, scale: 64),
            GeneratorSettings(dimension: 16, speed: 32, scale: 128),
            GeneratorSettings(dimension: 16, speed: 32, scale: 255),
            GeneratorSettings(dimension: 16, speed: 96, scale: 1),
            GeneratorSettings(dimension: 16, speed: 96, scale: 32),
            GeneratorSettings(dimension: 16, speed: 96, scale: 64),
            GeneratorSettings(dimension: 16, speed: 96, scale: 128),
            GeneratorSettings(dimension: 16, speed: 96, scale: 255),
            GeneratorSettings(dimension: 16, speed: 128, scale: 1),
            GeneratorSettings(dimension: 16, speed: 128, scale: 32),
            GeneratorSettings(dimension: 16, speed: 128, scale: 64),
            GeneratorSettings(dimension: 16, speed: 128, scale: 128),
            GeneratorSettings(dimension: 16, speed: 128, scale: 255),
            GeneratorSettings(dimension: 16, speed: 255, scale: 1),
            GeneratorSettings(dimension: 16, speed: 255, scale: 32),
            GeneratorSettings(dimension: 16, speed: 255, scale: 64),
            GeneratorSettings(dimension: 16, speed: 255, scale: 128),
            GeneratorSettings(dimension: 16, speed: 255, scale: 255),
          },
        );

  @override
  String describeValue(GeneratorSettings value) => value.toString();
}
