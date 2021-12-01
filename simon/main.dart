import 'solutions/index.dart';

const ONLY_SHOW_LAST = false;
final days = [
  Day1(),
];

void main() {
  ONLY_SHOW_LAST
      ? days.last.printSolutions()
      : days.forEach((day) => day.printSolutions());
}
