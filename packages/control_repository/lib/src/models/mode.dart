/// Represents the lamp mode.
enum GyverLampMode {
  /// Represents a sparkles mode.
  sparkles,

  /// Represents a fire mode.
  fire,

  /// Represents a vertical rainbow mode.
  rainbowVertical,

  /// Represents a horizontal rainbow mode.
  rainbowHorizontal,

  /// Represents a colors mode.
  colors,

  /// Represents a madness mode.
  madness,

  /// Represents a cloud mode.
  cloud,

  /// Represents a lava mode.
  lava,

  /// Represents a plasma mode.
  plasma,

  /// Represents a rainbow mode.
  rainbow,

  /// Represents a rainbow stripes mode.
  rainbowStripes,

  /// Represents a zebra mode.
  zebra,

  /// Represents a forest mode.
  forest,

  /// Represents a ocean mode.
  ocean,

  /// Represents a color mode.
  color,

  /// Represents a snow mode.
  snow,

  /// Represents a matrix mode.
  matrix,

  /// Represents a fireflies mode.
  fireflies;

  /// Returns [GyverLampMode] for the given [index]
  static GyverLampMode fromIndex(int index) {
    return GyverLampMode.values[index];
  }
}
