import '../utils/generic_day.dart';
import '../utils/parse_util.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  int solvePart1() {
    return solve(parseInput());
  }

  @override
  int solvePart2() {
    return solve(sumTriplets());
  }

  List<int> parseInput() {
    return ParseUtil.stringListToIntList(input.getPerLine());
  }

  int solve(List<int> input) {
    var tempDepth = input[0];

    return input.fold(0, (sum, depth) {
      if (depth > tempDepth) ++sum;
      tempDepth = depth;
      return sum;
    });
  }

  List<int> sumTriplets() {
    final input = parseInput();
    final triplets = <int>[];

    // a .map() would have been nice, but Dart does not give you access
    // to the index, thus it does not make sense here
    for (var i = 0; i < input.length - 2; ++i) {
      final sum = input[i] + input[i + 1] + input[i + 2];
      triplets.add(sum);
    }
    return triplets;
  }
}
