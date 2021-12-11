import 'dart:math' as math;

import '../utils/index.dart';

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  List<int> parseInput() {
    return ParseUtil.stringListToIntList(input.getBy(','));
  }

  @override
  int solvePart1() {
    final positions = parseInput();
    final median = _median(positions);
    return positions.fold<int>(0, (s, pos) => s + (pos - median).abs());
  }

  @override
  int solvePart2() {
    final positions = parseInput();
    final mean = _mean(positions), mCeil = mean.ceil(), mFloor = mean.floor();

    final ceil = positions.fold<int>(0, (s, pos) => s + _gaus((pos - mCeil)));
    final floor = positions.fold<int>(0, (s, pos) => s + _gaus((pos - mFloor)));

    return math.min(ceil, floor);
  }

  int _median(List<int> list) {
    list.sort((a, b) => a.compareTo(b));

    int middle = list.length ~/ 2;
    return list.length % 2 == 1
        ? list[middle]
        : ((list[middle - 1] + list[middle]) / 2.0).round();
  }

  double _mean(List<int> list) {
    return (list.reduce((a, b) => a + b) / list.length);
  }

  /// gauß = n(n+1)/2 \
  /// round gets called to cast it to int, the result is an interger by definition
  /// either way
  int _gaus(int i) {
    return ((i.abs() * (i.abs() + 1)) / 2).round();
  }
}
