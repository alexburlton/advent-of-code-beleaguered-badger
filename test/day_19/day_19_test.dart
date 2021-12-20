import 'package:beleaguered_badger/day_19/day_19.dart';
import 'package:beleaguered_badger/utils/point3d.dart';
import 'package:kt_dart/kt.dart';
import 'package:test/test.dart';

void main() {
  test('all orientations', () {
    final scanner = Scanner(listOf(Point3d(1, 2, 3)));
    final allOrientations = scanner.getAllOrientations();
    expect(allOrientations.size, equals(24));

    // Should have x, y and z once each in some combination
    final resultingPoints = allOrientations.map((scanner) => scanner.points[0]);
    for (var pt in resultingPoints.iter) {
      expect(pt.x.abs() + pt.y.abs() + pt.z.abs(), equals(6));
    }

    // All the points should be distinct
    expect(resultingPoints.distinct().size, equals(24));

    expect(resultingPoints.filter((pt) => pt.x.abs() == 1).size, equals(8));
    expect(resultingPoints.filter((pt) => pt.y.abs() == 1).size, equals(8));
    expect(resultingPoints.filter((pt) => pt.z.abs() == 1).size, equals(8));

    expect(resultingPoints.filter((pt) => pt.x.abs() == 2).size, equals(8));
    expect(resultingPoints.filter((pt) => pt.y.abs() == 2).size, equals(8));
    expect(resultingPoints.filter((pt) => pt.z.abs() == 2).size, equals(8));

    expect(resultingPoints.filter((pt) => pt.x.abs() == 3).size, equals(8));
    expect(resultingPoints.filter((pt) => pt.y.abs() == 3).size, equals(8));
    expect(resultingPoints.filter((pt) => pt.z.abs() == 3).size, equals(8));
  });
}