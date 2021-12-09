import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

import '../utils/index.dart';

typedef StringList = List<String>;
typedef Command = Tuple2<StringList, StringList>;

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  List<Command> parseInput() {
    return input.getPerLine().map((line) {
      final splitLine = line.split('|').map((s) => s.trim());
      final splitList = splitLine.map((l) => l.split(' ')).toList();
      return Tuple2(splitList[0], splitList[1]);
    }).toList();
  }

  @override
  int solvePart1() {
    return parseInput().fold<int>(0, (p, t) => p + _numberOfSegments(t.item2));
  }

  int _numberOfSegments(List<String> digits) {
    return digits.fold<int>(
        0, (prev, d) => [2, 3, 4, 7].contains(d.length) ? ++prev : prev);
  }

  @override
  int solvePart2() {
    final input = parseInput();
    // add the results of every input line together
    return input.fold<int>(0, (sum, tuple) {
      final loopup = _determineForTuple(tuple);
      // fold each digit together into empty string - gets parsed later
      final number = tuple.item2.fold<String>('', (prev, digit) {
        // get correct digit from lookup and append it to string
        return prev += loopup.entries
            .firstWhere((e) => SetEquality().equals(e.key, digit.toSet()))
            .value
            .toString();
      });
      return sum + int.parse(number);
    });
  }

  Map<Set<String>, int?> _determineForTuple(Command tuple) {
    final signals = tuple.item1.map((s) => s.toSet());
    // String is used as dart has no char
    Map<Set<String>, int?> setToDigit = Map();
    Map<int, Set<String>> digitToSet = Map();
    final setMap = (Set<String> key, int value) => setToDigit[key] = value;

    // fill lookups with unambiguous digits
    signals.forEach((signal) {
      setToDigit[signal] = _getUnambiguousDigit(signal);
      digitToSet[_getUnambiguousDigit(signal) ?? -1] = signal;
    });

    // create map of ambiguous digits
    Map<Set<String>, int?> ambiguous = Map.from(setToDigit)
      ..removeWhere((key, value) => value != null);

    // determine digits for 5-length segments
    ambiguous.keys.where((key) => key.length == 5).forEach((key) {
      if (key.intersection(digitToSet[1]!).length == 2)
        setMap(key, 3);
      else if (key.intersection(digitToSet[4]!).length == 2)
        setMap(key, 2);
      else
        setMap(key, 5);
    });

    // determine digits for 6-length segments
    ambiguous.keys.where((key) => key.length == 6).forEach((key) {
      if (key.intersection(digitToSet[1]!).length == 1)
        setMap(key, 6);
      else if (key.intersection(digitToSet[4]!).length == 4)
        setMap(key, 9);
      else
        setMap(key, 0);
    });

    return setToDigit;
  }
}

/// Determines digits that are not ambiguous \
/// Returns null for amb. signals
int? _getUnambiguousDigit(Set<String> signal) {
  switch (signal.length) {
    case 2:
      return 1;
    case 4:
      return 4;
    case 3:
      return 7;
    case 7:
      return 8;
    default:
      return null;
  }
}

// extension to create a set of characters from a string
extension on String {
  Set<String> toSet() {
    return this.split('').toSet();
  }
}
