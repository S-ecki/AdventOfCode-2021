import 'solutions/index.dart';
import 'utils/generic_day.dart';

const ONLY_SHOW_LAST = true;
final days = <GenericDay>[
  Day1(),
  Day2(),
  Day3(),
  Day4(),
];

void main() {
  ONLY_SHOW_LAST
      ? days.last.printSolutions()
      : days.forEach((day) => day.printSolutions());
}
