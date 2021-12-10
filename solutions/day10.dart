import 'dart:collection';

import 'package:collection/collection.dart';

import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  final corruptLineIndexes = <int>[];
  final lookup = Map<String, int>.unmodifiable({
    // correspond to part 1
    '(': 1,
    '[': 2,
    '{': 3,
    '<': 4,
    // correspond to part 2
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137,
  });

  @override
  List<String> parseInput() {
    return input.getPerLine().map((e) => e.trim()).toList();
  }

  @override
  int solvePart1() {
    final lines = parseInput();
    int cost = 0;

    outer:
    for (var i = 0; i < lines.length; ++i) {
      Queue<String> queue = Queue();

      for (final char in lines[i].split('')) {
        // add opening chars to queue
        if ('([{<'.contains(char))
          queue.add(char);
        // pop closing chars off queue
        else {
          final openChar = queue.removeLast();
          // if the popped char does not close the correct bracket, add its cost
          // to the accumulator and its line index to the corrptedLineIndexes
          // also stop computing for this line and continue with the next one
          if (!_isClosed(openChar, char)) {
            cost += lookup[char]!;
            corruptLineIndexes.add(i);
            continue outer;
          }
        }
      }
    }
    return cost;
  }

  @override
  int solvePart2() {
    final uncorruptedLines = parseInput()
        .whereIndexed((index, _) => !corruptLineIndexes.contains(index))
        .toList();

    final cost = <int>[];

    for (final line in uncorruptedLines) {
      final queue = <String>[];

      // add opening chars to queue and pop closing chars off queue for all chars
      line.split('').forEach((char) =>
          '([{<'.contains(char) ? queue.add(char) : queue.removeLast());

      // all lines have unclosed chars per definition
      // calculate their cost and add that cost to array
      cost.add(queue.reversed
          .fold<int>(0, (prev, char) => (prev * 5) + lookup[char]!));
    }

    // sort the individual costs and return the middle element
    cost.sort();
    return cost[(cost.length - 1) ~/ 2];
  }

  bool _isClosed(String open, String closed) {
    final lookup = {
      '(': ')',
      '[': ']',
      '{': '}',
      '<': '>',
    };
    return lookup[open] == closed;
  }
}
