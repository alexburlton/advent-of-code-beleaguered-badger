import 'package:beleaguered_badger/day_22/day_22.dart';
import 'package:beleaguered_badger/utils/point3d.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';
import 'package:test/test.dart';

void main() {
  void _verifyCubeVolume(String cubeStr) {
    final region = parseRegion("on x=-20..26,y=-36..17,z=-47..7");
    final points = getPoints(region);
    expect(region.getVolume(), equals(points.size));
  }
  test('cube volume', () {
    _verifyCubeVolume("on x=-20..26,y=-36..17,z=-47..7");
    _verifyCubeVolume("on x=-20..33,y=-21..23,z=-26..28");
    _verifyCubeVolume("on x=-22..28,y=-29..23,z=-38..16");
    _verifyCubeVolume("on x=-41..9,y=-7..43,z=-33..15");
  });
}


KtSet<Point3d> getPoints(Cube region) {
  final xValues = makeInclusiveList(region.xMin, region.xMax);
  final yValues = makeInclusiveList(region.yMin, region.yMax);
  final zValues = makeInclusiveList(region.zMin, region.zMax);

  return xValues.flatMap((x) => yValues.flatMap((y) => zValues.map((z) => Point3d(x, y, z)))).toSet();
}