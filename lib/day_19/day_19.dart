import 'dart:core';
import 'package:beleaguered_badger/utils/point3d.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';
import 'package:trotter/trotter.dart';

class Scanner {
  final Point3d position;
  final KtList<Point3d> points;

  const Scanner(this.points, [this.position=const Point3d(0, 0, 0)]);

  KtList<Scanner> getAllOrientations() => getDifferentFacings().flatMap((scanner) => scanner.getRotations());

  /// Assumed default is facing X, with Z going left to right and Y going bottom to top.
  /// Then the facings are:
  ///
  /// x,y,z (identity)
  /// -x,y,-z (face backwards)
  /// y,-x,z (face up)
  /// -y,x,z (face down)
  /// -z,y,x (face left)
  /// z,y,-x (face right)
  KtList<Scanner> getDifferentFacings() {
    final backwards = points.map((pt) => Point3d(-pt.x, pt.y, -pt.z));
    final up = points.map((pt) => Point3d(pt.y, -pt.x, pt.z));
    final down = points.map((pt) => Point3d(-pt.y, pt.x, pt.z));
    final left = points.map((pt) => Point3d(-pt.z, pt.y, pt.x));
    final right = points.map((pt) => Point3d(pt.z, pt.y, -pt.x));
    return listOf(this, Scanner(backwards), Scanner(up), Scanner(down), Scanner(left), Scanner(right));
  }

  /// Assume we're pointing in the x direction, with Z going left to right and Y going bottom to top.
  /// Then the 4 rotations are:
  ///
  /// x,y,z (identity)
  /// x,z,-y (clockwise 90)
  /// x,-y,-z (clockwise 180)
  /// x,-z,y (clockwise 270)
  KtList<Scanner> getRotations() {
    final rotate90 = points.map((pt) => Point3d(pt.x, pt.z, -pt.y));
    final rotate180 = points.map((pt) => Point3d(pt.x, -pt.y, -pt.z));
    final rotate270 = points.map((pt) => Point3d(pt.x, -pt.z, pt.y));
    return listOf(this, Scanner(rotate90), Scanner(rotate180), Scanner(rotate270));
  }

  Scanner translate(Point3d translation) {
    final newPoints = points.map((pt) => pt + translation);
    return Scanner(newPoints, translation);
  }
}

KtList<Scanner> _parseInput() {
  final scannerSections = readDoubleSpacedList('day_19/input.txt');
  return scannerSections.map(_parseScanner);
}

Scanner _parseScanner(String inputSection) {
  final lines = inputSection.split('\n').sublist(1);
  final points = lines.map(Point3d.fromString).toList().toKtList();
  return Scanner(points);
}

void main(List<String> arguments) {
  final scanners = findCorrectlyOrientedScanners();
  partA(scanners);
  partB(scanners);
}

void partA(KtList<Scanner> correctScanners) {
  print(correctScanners.flatMap((scanner) => scanner.points).distinct().size);
}

void partB(KtList<Scanner> correctScanners) {
  final pairs = Combinations<Scanner>(2, correctScanners.asList())().toList().toKtList();
  final dist = pairs.map((pair) => _getManhattenDistance(pair[0], pair[1])).max()!;
  print(dist);
}

int _getManhattenDistance(Scanner scannerOne, Scanner scannerTwo) => scannerOne.position.manhattenFrom(scannerTwo.position);

KtList<Scanner> findCorrectlyOrientedScanners() {
  final scanners = _parseInput();
  final correctScanners = mutableListOf(scanners[0]);
  final pendingScanners = scanners.toMutableList();
  pendingScanners.removeAt(0);

  while (pendingScanners.isNotEmpty()) {
    for (var i=pendingScanners.size-1; i>=0; i--) {
      final scannerToOrient = pendingScanners[i];
      final result = _attemptToFindPair(correctScanners.toList(), scannerToOrient);
      if (result != null) {
        pendingScanners.removeAt(i);
        correctScanners.add(result);
        print('Matched a scanner - ${correctScanners.size} scanners located in total');
      }
    }
  }

  return correctScanners.toList();
}

Scanner? _attemptToFindPair(KtList<Scanner> locatedScanners, Scanner scanner) {
  final allOrientations = scanner.getAllOrientations();
  for (var correctScanner in locatedScanners.iter) {
    for (var orientation in allOrientations.iter) {
      final result = _testOrientation(orientation, correctScanner);
      if (result != null) {
        return result;
      }
    }
  }

  return null;
}

Scanner? _testOrientation(Scanner scanner, Scanner controlScanner) {
  for (var pt in scanner.points.iter) {
    for (var knownPt in controlScanner.points.iter) {
      final diff = knownPt - pt;
      final translatedScanner = scanner.translate(diff);

      final overlap = translatedScanner.points.intersect(controlScanner.points);
      if (overlap.size == 12) {
        return translatedScanner;
      }
    }
  }

  return null;
}