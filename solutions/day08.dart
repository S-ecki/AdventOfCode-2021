import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

import '../utils/index.dart';

typedef StringList = List<String>;
typedef Command = Tuple2<StringList, StringList>;

/// This code is an abomination and I m sorry for everyone reading it :)
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
    // final input = ;
    return parseInput().fold<int>(0, (p, t) => p + _numberOfSegments(t.item2));
  }

  int _numberOfSegments(List<String> digits) {
    return digits.fold<int>(
        0, (prev, d) => [2, 3, 4, 7].contains(d.length) ? ++prev : prev);
  }

  @override
  int solvePart2() {
    final input = parseInput();
    final returnValue = input.fold<int>(0, (sum, tuple) {
      final loopup = _determineForTuple(tuple);
      final number = tuple.item2.fold<String>('', (prev, digit) {
        final s = loopup.entries
            .firstWhere((e) {
              return SetEquality().equals(e.key, digit.toSet());
            })
            .value
            .toString();
        return prev += s;
      });
      return sum + int.parse(number);
    });
    return returnValue;
  }

  Map<Set<String>, int?> _determineForTuple(Command tuple) {
    final signals = tuple.item1.map((s) => s.toSet());
    Map<Set<String>, int?> setToDigit = Map(); // String is only char!
    Map<int, Set<String>> digitToSet = Map(); // String is only char!

    signals.forEach((signal) {
      setToDigit[signal] = _getDigit(signal);
      digitToSet[_getDigit(signal) ?? -1] = signal;
    });

    Map<Set<String>, int?> ambiguous = Map.from(setToDigit)
      ..removeWhere((key, value) => value != null);

    for (var key in ambiguous.keys) {
      if (key.length == 5) {
        if (key.intersection(digitToSet[1]!).length == 2) {
          setToDigit[key] = 3;
        } else if (key.intersection(digitToSet[4]!).length == 2) {
          setToDigit[key] = 2;
        } else {
          setToDigit[key] = 5;
        }
      } else if (key.length == 6) {
        if (key.intersection(digitToSet[1]!).length == 1) {
          setToDigit[key] = 6;
        } else if (key.intersection(digitToSet[4]!).length == 4) {
          setToDigit[key] = 9;
        } else {
          setToDigit[key] = 0;
        }
      } else {
        throw Exception();
      }
    }
    return setToDigit;
  }
}

/// Determines digits that are not ambiguous \
/// Returns null for amb. signals
int? _getDigit(Set<String> signal) {
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

extension on String {
  Set<String> toSet() {
    return this.split('').toSet();
  }
}
