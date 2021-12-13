import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  late Tuple2<int, int> solution;

  @override
  Field<int> parseInput() => ParseUtil.stringListToIntField(input.getPerLine());

  @override
  int solvePart1() {
    solution = solve();
    return solution.x;
  }

  @override
  int solvePart2() {
    return solution.y;
  }

  Tuple2<int, int> solve() {
    final board = parseInput();
    final boardSize = Tuple2(board.height, board.width);

    late Tuple2<int, int> solution = Tuple2(0, 0);

    // hold the results for the parts respectively
    int flashCount = 0;
    int roundCount = 0;

    // loop breaks as soon as all octupuses flash at the same time, giving
    // us the result to part 2 (the round where this happens)
    while (true) {
      // for part 1, we count the flashes for the first 100 rounds
      if (roundCount++ == 100) {
        solution = solution.withItem1(flashCount);
      }

      final pointsToFlash = <Position>{};
      // is needed so points do not flash multiple times per round
      final pointsDidFlash = <Position>{};

      board.forEach((x, y) {
        // increment each position first and check if any flash
        board.increment(x, y);
        if (board.getValueAt(x, y) >= 10) pointsToFlash.add(Position(x, y));
      });

      // now flash - loop as new points that flash may arise
      while (pointsToFlash.isNotEmpty) {
        // take any flashpoint and look for neighboars to flash
        final flashPoint = pointsToFlash.first;
        pointsToFlash.remove(flashPoint);
        pointsDidFlash.add(flashPoint);

        // take all neighbours that will get flashed, but remove already
        // flashed to avoid infinite loops
        final neighboursToFlash = board
            .neighbours(flashPoint.x, flashPoint.y)
            .toSet()
          ..removeAll(pointsDidFlash);

        neighboursToFlash.forEach((p) {
          board.increment(p.x, p.y);
          if (board.getValueAt(p.x, p.y) >= 10)
            pointsToFlash.add(Position(p.x, p.y));
        });
      }

      final flashesBeforeRound = flashCount;
      // loop over board and flash all with value >= 10
      board.forEach((x, y) {
        if (board.getValueAt(x, y) >= 10) {
          ++flashCount;
          board.setValueAt(x, y, 0);
        }
      });

      // if the flashcount increased this round by the board area, it means
      // that every point flashed. the round this happens in is our part 2 solution
      if (flashCount - flashesBeforeRound == boardSize.x * boardSize.y) {
        solution = solution.withItem2(roundCount);
        break;
      }
    }
    return solution;
  }
}
