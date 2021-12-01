import 'package:kt_dart/kt.dart';
import 'package:test/test.dart';
import 'package:beleaguered_badger/day_1_2020/day_1_2020.dart';

final KtList<int> testReport = listOf(1721, 979, 366, 299, 675, 1456);

void main() {
    test('sums to 2020', () {
      expect(sumsTo2020([2000, 15, 5]), isTrue);
      expect(sumsTo2020([1800, 220]), isTrue);
      expect(sumsTo2020([2020]), isTrue);


      expect(sumsTo2020([2000, 15, 6]), isFalse);
      expect(sumsTo2020([1800, 15, 4]), isFalse);
      expect(sumsTo2020([2019]), isFalse);
    });

    test('Part A', () {
      expect(getExpenseReportProduct(testReport, 2), equals(514579));
    });

    test('Part B', () {
      expect(getExpenseReportProduct(testReport, 3), equals(241861950));
    });
}