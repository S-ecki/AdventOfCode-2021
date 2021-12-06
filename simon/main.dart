import 'solutions/index.dart';
import 'utils/generic_day.dart';

const ONLY_SHOW_LAST = true;
final days = <GenericDay>[
  Day01(),
  Day02(),
  Day03(),
  Day04(),
  Day05(),
  Day06(),
];

void main() {
  ONLY_SHOW_LAST
      ? days.last.printSolutions()
      : days.forEach((day) => day.printSolutions());
}
