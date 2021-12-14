import '../utils/index.dart';

class Polymerization {
  // Holds chair-pair as key and Tuple of char-pairs resulting from a split as value
  Map<String, Tuple2<String, String>> lookup;

  /// Holds char-pair as key and amount of occurances as value
  Map<String, int> state;

  Polymerization(this.state, this.lookup);

  /// Adds a new char-pair to the state
  void statePutPair(String pair, [int times = 1]) =>
      state[pair] = !state.containsKey(pair) ? times : state[pair]! + times;

  int get maxCharValue => max(charCounts)!;

  int get minCharValue => min(charCounts)!;

  /// counts the occurance of individual characters in state to solve puzzle \
  /// values get halved as pairs appear 2 times in state
  Iterable<int> get charCounts {
    final counter = <String, int>{};

    // get individual chars from pair and add their occurances to the counter
    state.forEach((pair, times) {
      pair.split('').forEach((char) => counter.putPair(char, times));
    });

    return counter.values.map((value) => (value / 2).ceil());
  }
}

class Day14 extends GenericDay {
  Day14() : super(14);

  @override
  int solvePart1() => solve(10);

  @override
  int solvePart2() => solve(40);

  int solve(int steps) {
    final poly = parseInput();

    for (var i = 0; i < steps; ++i) {
      final copiedState = {...(poly.state)};
      // drop old state and override with new one
      poly.state.clear();
      copiedState.forEach((key, times) => poly.lookup[key]!
          .toList()
          .forEach((pair) => poly.statePutPair(pair, times)));
    }

    return poly.maxCharValue - poly.minCharValue;
  }

  @override
  Polymerization parseInput() {
    Map<String, int> state = {};
    Map<String, Tuple2<String, String>> lookup = Map();

    final lines = input.getPerLine();

    lines.forEach((line) {
      if (line.contains('->')) {
        final parts = line.trim().split(' -> ');
        final firstString = parts.first.substring(0, 1) + parts.last;
        final secondString = parts.last + parts.first.substring(1);
        lookup[parts[0]] = Tuple2(firstString, secondString);
      } else if (isNotBlank(line)) {
        for (var i = 0; i < line.length - 2; ++i) {
          // takes 2 characters
          final pair = line.substring(i, i + 2);
          state[pair] = !state.containsKey(pair) ? 1 : state[pair]! + 1;
        }
      }
    });
    return Polymerization(state, lookup);
  }
}

extension on Map<String, int> {
  void putPair(String pair, [int times = 1]) =>
      this[pair] = !this.containsKey(pair) ? times : this[pair]! + times;
}
