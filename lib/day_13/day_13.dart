import 'package:beleaguered_badger/utils/point2d.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class DottedPaper {
  final KtList<Point2d> dottedPoints;

  const DottedPaper(this.dottedPoints);

  DottedPaper applyFold(FoldInstruction fold) {
    final pointsToKeep = dottedPoints.filter((pt) => fold.shouldKeepPoint(pt));
    final pointsToFold = dottedPoints.filter((pt) => fold.isFoldedPoint(pt));
    final newFoldedPoints = pointsToFold.map((pt) => fold.getLocationAfterFold(pt));

    final newDottedPoints = (pointsToKeep + newFoldedPoints).distinct();
    return DottedPaper(newDottedPoints);
  }

  void printGrid() {
    final xMax = dottedPoints.map((pt) => pt.x).max()!;
    final yMax = dottedPoints.map((pt) => pt.y).max()!;

    final map = mutableMapFrom<Point2d, String>();
    for (var x=0; x<=xMax; x++) {
      for (var y=0; y<=yMax; y++) {
        final pt = Point2d(x, y);
        final value = dottedPoints.contains(pt) ? '#' : '.';
        map[pt] = value;
      }
    }

    map.printGrid();
  }

  int countDots() => dottedPoints.size;
}

class FoldInstruction {
  final int position;
  final bool vertical;

  const FoldInstruction(this.position, this.vertical);

  bool shouldKeepPoint(Point2d pt) => vertical ? pt.y < position : pt.x < position;
  bool isFoldedPoint(Point2d pt) => vertical ? pt.y > position : pt.x > position;

  Point2d getLocationAfterFold(Point2d pt) {
    if (vertical) {
      final yDiff = pt.y - position;
      return Point2d(pt.x, position - yDiff);
    }

    final xDiff = pt.x - position;
    return Point2d(position - xDiff, pt.y);
  }
}

void main(List<String> arguments) {
  final input = readDoubleSpacedList('day_13/input.txt');
  final dots = input[0].split('\n').toKtList();
  final folds = input[1].split('\n').map(_parseFold).toList();
  final paper = _constructOriginalPaper(dots);

  partA(paper, folds);
  partB(paper, folds);
}

void partA(DottedPaper paper, List<FoldInstruction> instructions) {
  final result = paper.applyFold(instructions[0]);
  print(result.countDots());
}

void partB(DottedPaper paper, List<FoldInstruction> folds) {
  final result = folds.fold(paper, (DottedPaper currentPaper, instruction) => currentPaper.applyFold(instruction));
  result.printGrid();
}

DottedPaper _constructOriginalPaper(KtList<String> pointStrings) {
  final points = pointStrings.map(_parsePoint);
  return DottedPaper(points);
}

Point2d _parsePoint(String pointStr) {
  final xAndY = pointStr.split(',');
  return Point2d(int.parse(xAndY[0]), int.parse(xAndY[1]));
}

FoldInstruction _parseFold(String foldStr) {
  final vertical = foldStr.contains('y=');
  final position = int.parse(foldStr.split('=')[1]);
  return FoldInstruction(position, vertical);
}
