import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  List<int> parseInput() {
    // list of fish
    final fish = ParseUtil.stringListToIntList(input.getBy(','));
    // list with number of fish for each age, where age == index
    final ages = List.filled(9, 0);
    fish.forEach((f) => ++ages[f]);

    return ages;
  }

  @override
  int solvePart1() {
    return solve(80);
  }

  @override
  int solvePart2() {
    return solve(256);
  }

  int solve(int days) {
    final ages = parseInput();

    for (var i = 0; i < days; ++i) {
      ages[(7 + i) % 9] += ages[i % 9];
    }

    return ages.reduce((sum, age) => sum + age);
  }
}
