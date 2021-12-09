import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  Set<Line> parseInput() {
    Set<Line> instructions = Set();

    input.getPerLine().map((line) => line.split(' -> ')).forEach(
      (parts) {
        final startPosition = Position.fromList(
            ParseUtil.stringListToIntList(parts[0].split(',')));
        final endPosition = Position.fromList(
            ParseUtil.stringListToIntList(parts[1].split(',')));
        instructions.add(Line(startPosition, endPosition));
      },
    );

    return instructions;
  }

  int solve(Set<Line> instructions, bool allowDiagonal) {
    var map = Map();

    instructions.forEach((i) => i
        .generatePositions(allowDiagonal)
        .forEach((x) => map[x] = !map.containsKey(x) ? 1 : map[x] + 1));

    return map.values.where((value) => value > 1).length;
  }

  @override
  int solvePart1() {
    final filteredInstructions = _filterInstructions(parseInput());
    return solve(filteredInstructions, false);
  }

  @override
  int solvePart2() {
    final instructions = parseInput();
    return solve(instructions, true);
  }

  Set<Line> _filterInstructions(Set<Line> instructions) {
    return instructions.where((line) => !line.isDiagonal).toSet();
  }
}

class Line {
  final x1, x2, y1, y2;

  Line(Position start, Position end)
      : x1 = start.item1,
        x2 = end.item1,
        y1 = start.item2,
        y2 = end.item2;

  bool get isDiagonal => (x1 != x2 && y1 != y2);

  Set<Position> generatePositions(bool allowDiagonal) {
    return allowDiagonal
        ? _generateAllPositions()
        : _generateNonDiagonalPositions();
  }

  Set<Position> _generateAllPositions() {
    return !isDiagonal
        ? _generateNonDiagonalPositions()
        : _generateDiagonalPositions();
  }

  Set<Position> _generateDiagonalPositions() {
    assert(!(x1 == x2 || y1 == y2));
    Set<Position> linePositions = Set();

    if (x1 < x2) {
      int y = y1;
      // topleft to bottomright
      if (y1 < y2) {
        // iterate left to right
        for (var i = x1; i <= x2; ++i) {
          linePositions.add(Position(i, y++));
        }
        // leftbottom to topright
      } else {
        // iterate left to right
        for (var i = x1; i <= x2; ++i) {
          linePositions.add(Position(i, y--));
        }
      }
    } else if (x1 > x2) {
      int item1 = x1;
      // topright to bottomleft
      if (y1 < y2) {
        for (var i = y1; i <= y2; ++i) {
          linePositions.add(Position(item1--, i));
        }
        // bottomright to topleft
      } else {
        for (var i = y1; i >= y2; --i) {
          linePositions.add(Position(item1--, i));
        }
      }
    }
    return linePositions;
  }

  Set<Position> _generateNonDiagonalPositions() {
    Set<Position> linePositions = Set();
    int begin = 0, finish = 0;

    // vertical
    if (x1 == x2) {
      if (y1 < y2) {
        begin = y1;
        finish = y2;
      } else {
        begin = y2;
        finish = y1;
      }

      for (var i = begin; i <= finish; ++i) {
        linePositions.add(Position(x1, i));
      }
      // horizontal
    } else {
      if (x1 < x2) {
        begin = x1;
        finish = x2;
      } else {
        begin = x2;
        finish = x1;
      }

      for (var i = begin; i <= finish; ++i) {
        linePositions.add(Position(i, y1));
      }
    }
    return linePositions;
  }
}
