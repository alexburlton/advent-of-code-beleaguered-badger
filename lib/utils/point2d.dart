class SystemHash {
  static int combine(int hash, int value) {
    hash = 0x1fffffff & (hash + value);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  static int hash2(int v1, int v2) {
    int hash = 0;
    hash = combine(hash, v1);
    hash = combine(hash, v2);
    return finish(hash);
  }
}

class Point2d {
  final int x;
  final int y;

  const Point2d(this.x, this.y);

  @override
  String toString() => 'Point($x, $y)';

  @override
  bool operator ==(Object other) =>
      other is Point2d && x == other.x && y == other.y;

  @override
  int get hashCode => SystemHash.hash2(x.hashCode, y.hashCode);

  Point2d operator +(Point2d other) => Point2d(x + other.x, y + other.y);

  Point2d operator -(Point2d other) => Point2d(x - other.x, y - other.y);

  int manhattenFrom(Point2d other) {
    return (x - other.x).abs() + (y - other.y).abs();
  }

  static Point2d fromString(String pointStr) {
    final coords = pointStr.split(',').map((value) => int.parse(value)).toList();
    return Point2d(coords[0], coords[1]);
  }
}