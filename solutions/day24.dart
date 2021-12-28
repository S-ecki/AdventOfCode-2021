import '../utils/index.dart';

class Day24 extends GenericDay {
  Day24() : super(24);

  @override
  parseInput() {}

  @override
  int solvePart1() {
    // To solve this puzzle, a form of meta-programing and reverse engineering
    // needed to be done. This would have been easier in languages like c or
    // python. Dart was not suitable for this job.
    // Due to the periodic nature of the puzzle input (some patterns appear) time
    // after time), it was pretty straight-forward to solve it with pen and papaer.
    return 753;
  }

  @override
  int solvePart2() {
    return 3471;
  }
}
