import 'input_util.dart';

/// Provides the [InputUtil] for given day and a [printSolution] method.
abstract class GenericDay {
  final int day;
  final InputUtil input;

  GenericDay(int day)
      : day = day,
        input = InputUtil(day);

  dynamic parseInput();
  int? solvePart1();
  int? solvePart2();

  void printSolutions() {
    print("-------------------------");
    print("         Day $day        ");
    final solution1 = solvePart1();
    if (solution1 != null) print("Solution for puzzle one: $solution1");
    final solution2 = solvePart2();
    if (solution2 != null) print("Solution for puzzle two: $solution2");
    print("\n");
  }
}
