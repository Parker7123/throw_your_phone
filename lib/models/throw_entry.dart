class ThrowEntry {
  double distance, height;
  ThrowType throwType;

  ThrowEntry(this.distance, this.height, this.throwType);
}

enum ThrowType { horizontal, vertical }
