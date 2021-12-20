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

  static int hash3(int v1, int v2, int v3) {
    int hash = 0;
    hash = combine(hash, v1);
    hash = combine(hash, v2);
    hash = combine(hash, v3);
    return finish(hash);
  }
}

class Point3d {
  final int x;
  final int y;
  final int z;

  const Point3d(this.x, this.y, this.z);

  @override
  String toString() => 'Point($x, $y,$z)';

  @override
  bool operator ==(Object other) =>
      other is Point3d && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => SystemHash.hash3(x.hashCode, y.hashCode, z.hashCode);

  Point3d operator +(Point3d other) => Point3d(x + other.x, y + other.y, z + other.z);

  Point3d operator -(Point3d other) => Point3d(x - other.x, y - other.y, z - other.z);

  int manhattenFrom(Point3d other) {
    return (x - other.x).abs() + (y - other.y).abs() + (z - other.z).abs();
  }

  static Point3d fromString(String pointStr) {
    final coords = pointStr.split(',').map((value) => int.parse(value)).toList();
    return Point3d(coords[0], coords[1], coords[2]);
  }
}