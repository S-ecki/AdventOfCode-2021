import 'solutions/index.dart';
import 'utils/generic_day.dart';

const ONLY_SHOW_LAST = false;
final days = <GenericDay>[
  Day01(),
  Day02(),
  Day03(),
  Day04(),
  Day05(),
  Day06(),
  Day07(),
  Day08(),
  Day09(),
  Day10(),
  Day11(),
  Day12(),
  Day13(),
  Day14(),
  Day15(),
  Day17(),
  Day20(),
  Day21(),
  Day22(),
  Day23(),
  Day24(),
  Day25(),
];

void main() {
  ONLY_SHOW_LAST
      ? days.last.printSolutions()
      : days.forEach((day) => day.printSolutions());
}
