/// Extension on [num] which remaps number to the new range.
extension NumRemap on num {
  /// Remaps number from old range to the new one.
  double remap(num fromLow, num fromHigh, num toLow, num toHigh) {
    return (this - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow;
  }
}
