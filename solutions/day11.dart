import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  Board parseInput() {
    return input
        .getPerLine()
        .map((e) => ParseUtil.stringListToIntList(e.trim().split('')))
        .toList();
  }

  @override
  int solvePart1() {
    final board = parseInput();
    final height = board.length;
    final width = board[0].length;
    int flashes = 0;

    //gameloop
    for (var i = 0; i < 100; ++i) {
      final flashPoints = <Position>{};
      final didFlash = <Position>{};
      // loop board
      for (var y = 0; y < board.length; ++y) {
        for (var x = 0; x < board[y].length; ++x) {
          // increment first
          ++board[y][x];
          // check for flashes
          if (board[y][x] >= 10) {
            flashPoints.add(Position(x, y));
          }
        }
      }
      // now flash
      while (flashPoints.isNotEmpty) {
        // take first flashpoint and get neighboars to falsh
        final pos = flashPoints.first;
        flashPoints.remove(pos);
        didFlash.add(pos);

        final flashNeigh = _neighboards(pos.item1, pos.item2, height, width);
        flashNeigh.removeWhere((p) => didFlash.contains(p));

        flashNeigh.forEach((p) {
          ++board[p.item2][p.item1];
          if (board[p.item2][p.item1] >= 10) {
            flashPoints.add(Position(p.item1, p.item2));
          }
        });
      }

      for (var y = 0; y < board.length; ++y) {
        for (var x = 0; x < board[y].length; ++x) {
          if (board[y][x] >= 10) {
            ++flashes;
            board[y][x] = 0;
          }
        }
      }
    }

    return flashes;
  }

  List<Position> _neighboards(int x, int y, int height, int width) {
    final positions = <Position>[];
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

  @override
  int solvePart2() {
    final board = parseInput();
    final height = board.length;
    final width = board[0].length;

    //gameloop
    int step = 0;
    while (true) {
      ++step;
      final flashPoints = <Position>{};
      final didFlash = <Position>{};
      // loop board
      for (var y = 0; y < board.length; ++y) {
        for (var x = 0; x < board[y].length; ++x) {
          // increment first
          ++board[y][x];
          // check for flashes
          if (board[y][x] >= 10) {
            flashPoints.add(Position(x, y));
          }
        }
      }
      // now flash
      while (flashPoints.isNotEmpty) {
        // take first flashpoint and get neighboars to falsh
        final pos = flashPoints.first;
        flashPoints.remove(pos);
        didFlash.add(pos);

        final flashNeigh = _neighboards(pos.item1, pos.item2, height, width);
        flashNeigh.removeWhere((p) => didFlash.contains(p));

        flashNeigh.forEach((p) {
          ++board[p.item2][p.item1];
          if (board[p.item2][p.item1] >= 10) {
            flashPoints.add(Position(p.item1, p.item2));
          }
        });
      }

      int flashcount = 0;
      for (var y = 0; y < board.length; ++y) {
        for (var x = 0; x < board[y].length; ++x) {
          if (board[y][x] >= 10) {
            ++flashcount;
            board[y][x] = 0;
          }
        }
      }
      if (flashcount == height * width) {
        return step;
      }
    }
  }
}
