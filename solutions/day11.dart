import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  late Tuple2<int, int> solution;

  @override
  Board parseInput() => ParseUtil.stringListToBoard(input.getPerLine());

  @override
  int solvePart1() {
    solution = solve();
    return solution.item1;
  }

  @override
  int solvePart2() {
    return solution.item2;
  }

  Tuple2<int, int> solve() {
    final board = parseInput();
    final boardSize = Tuple2(board.length, board[0].length);
    // convenience method to loop over 2D array (board)
    final forBoard = (VoidFieldCallback f) {
      for (var y = 0; y < board.length; ++y) {
        for (var x = 0; x < board[y].length; ++x) {
          f(x, y);
        }
      }
    };

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

      forBoard((x, y) {
        // increment each position first and check if any flash
        ++board[y][x];
        if (board[y][x] >= 10) pointsToFlash.add(Position(x, y));
      });

      // now flash - loop as new points that flash may arise
      while (pointsToFlash.isNotEmpty) {
        // take any flashpoint and look for neighboars to flash
        final flashPoint = pointsToFlash.first;
        pointsToFlash.remove(flashPoint);
        pointsDidFlash.add(flashPoint);

        // take all neighbours that will get flashed, but remove already
        // flashed to avoid infinite loops
        final neighboursToFlash = _neighboards(flashPoint.item1,
            flashPoint.item2, boardSize.item1, boardSize.item2)
          ..removeAll(pointsDidFlash);

        neighboursToFlash.forEach((p) {
          ++board[p.item2][p.item1];
          if (board[p.item2][p.item1] >= 10)
            pointsToFlash.add(Position(p.item1, p.item2));
        });
      }

      final flashesBeforeRound = flashCount;
      // loop over board and flash all with value >= 10
      forBoard((x, y) {
        if (board[y][x] >= 10) {
          ++flashCount;
          board[y][x] = 0;
        }
      });

      // if the flashcount increased this round by the board area, it means
      // that every point flashed. the round this happens in is our part 2 solution
      if (flashCount - flashesBeforeRound ==
          boardSize.item1 * boardSize.item2) {
        solution = solution.withItem2(roundCount);
        break;
      }
    }
    return solution;
  }

  Set<Position> _neighboards(int x, int y, int height, int width) {
    final positions = <Position>{};
    for (var xx = x - 1; xx <= x + 1; ++xx) {
      for (var yy = y - 1; yy <= y + 1; ++yy) {
        if (xx >= 0 &&
            yy >= 0 &&
            (yy != y || xx != x) &&
            xx < width &&
            yy < height) {
          positions.add(Position(xx, yy));
        }
      }
    }
    return positions;
  }
}
