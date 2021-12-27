import '../utils/index.dart';

class Cucumbers {
  Cucumbers(this.right, this.down, this.height, this.width);
  final Set<Position> right;
  final Set<Position> down;
  final int height;
  final int width;

  /// Returns `true` if one of the two operations still alter the state
  bool move() {
    bool one = moveRight();
    bool two = moveDown();
    return one || two;
  }

  /// Moves all the `>` characters to the right if possible
  bool moveRight() {
    final moving = <Position>{};

    for (final cuc in right) {
      if (!right.contains(Position((cuc.x + 1) % width, cuc.y)) &&
          !down.contains(Position((cuc.x + 1) % width, cuc.y))) {
        moving.add(cuc);
      }
    }

    right.removeAll(moving);
    right.addAll(moving.map((c) => Position((c.x + 1) % width, c.y)));
    return moving.isNotEmpty;
  }

  /// Moves all the `v` characters to down if possible
  bool moveDown() {
    final moving = <Position>{};

    for (final cuc in down) {
      if (!right.contains(Position(cuc.x, (cuc.y + 1) % height)) &&
          !down.contains(Position(cuc.x, (cuc.y + 1) % height))) {
        moving.add(cuc);
      }
    }

    down.removeAll(moving);
    down.addAll(moving.map((c) => Position(c.x, (c.y + 1) % height)));
    return moving.isNotEmpty;
  }
}

class Day25 extends GenericDay {
  Day25() : super(25);

  @override
  Cucumbers parseInput() {
    final right = <Position>{};
    final down = <Position>{};
    final lines = input.getPerLine();

    for (var y = 0; y < lines.length; ++y) {
      for (var x = 0; x < lines[0].length; ++x) {
        if (lines[y][x] == '>') {
          right.add(Position(x, y));
        } else if (lines[y][x] == 'v') {
          down.add(Position(x, y));
        }
      }
    }

    return Cucumbers(right, down, lines.length, lines[0].length);
  }

  @override
  int solvePart1() {
    final cucumbers = parseInput();

    var counter = 1;
    while (cucumbers.move()) {
      ++counter;
    }

    return counter;
  }

  @override
  int solvePart2() {
    // there is no part 1 for this day
    return 0;
  }
}
