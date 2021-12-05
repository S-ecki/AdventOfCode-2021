import '../utils/generic_day.dart';
import '../utils/parse_util.dart';

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

class Position {
  Position(this.x, this.y);
  Position.fromList(List<int> pos)
      : assert(pos.length == 2),
        x = pos[0],
        y = pos[1];

  final int x;
  final int y;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Position && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class Line {
  Line(this.start, this.end);
  Position start;
  Position end;

  bool get isDiagonal => (start.x != end.x && start.y != end.y);

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
    assert(!(start.x == end.x || start.y == end.y));
    Set<Position> linePositions = Set();

    if (start.x < end.x) {
      int y = start.y;
      // topleft to bottomright
      if (start.y < end.y) {
        // iterate left to right
        for (var i = start.x; i <= end.x; ++i) {
          linePositions.add(Position(i, y++));
        }
        // leftbottom to topright
      } else {
        // iterate left to right
        for (var i = start.x; i <= end.x; ++i) {
          linePositions.add(Position(i, y--));
        }
      }
    } else if (start.x > end.x) {
      int x = start.x;
      // topright to bottomleft
      if (start.y < end.y) {
        for (var i = start.y; i <= end.y; ++i) {
          linePositions.add(Position(x--, i));
        }
        // bottomright to topleft
      } else {
        for (var i = start.y; i >= end.y; --i) {
          linePositions.add(Position(x--, i));
        }
      }
    }
    return linePositions;
  }

  Set<Position> _generateNonDiagonalPositions() {
    Set<Position> linePositions = Set();
    int begin = 0, finish = 0;

    // vertical
    if (start.x == end.x) {
      if (start.y < end.y) {
        begin = start.y;
        finish = end.y;
      } else {
        begin = end.y;
        finish = start.y;
      }

      for (var i = begin; i <= finish; ++i) {
        linePositions.add(Position(start.x, i));
      }
      // horizontal
    } else {
      if (start.x < end.x) {
        begin = start.x;
        finish = end.x;
      } else {
        begin = end.x;
        finish = start.x;
      }

      for (var i = begin; i <= finish; ++i) {
        linePositions.add(Position(i, start.y));
      }
    }
    return linePositions;
  }
}
