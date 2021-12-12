import 'package:tuple/tuple.dart';

import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  final lowPoints = <Position>[];

  @override
  TBoard parseInput() {
    return input
        .getPerLine()
        .map((e) => ParseUtil.stringListToIntList(e.trim().split('')))
        .toList();
  }

  @override
  int solvePart1() {
    final board = parseInput();

    for (var y = 0; y < board.length; y++) {
      for (var x = 0; x < board[y].length; x++) {
        // checks if any neighbour has lower value
        // if not, appends it to lowpoints
        if (_neighbours(board, y, x)
                .where((n) => board[n.item2][n.item1] <= board[y][x])
                .length ==
            0) lowPoints.add(Tuple2(x, y));
      }
    }

    final lowestValues = lowPoints.map((e) => board[e.item2][e.item1]).toList();
    return lowestValues.fold<int>(0, (prev, val) => prev += val + 1);
  }

  @override
  int solvePart2() {
    final board = parseInput();
    final basins = <Basin>{};

    // done to disregard that pos, as 9s are not taken into account
    final ignorePosition = (Position pos) => board[pos.item2][pos.item1] = 9;

    // loop over lowpoints -> search each for a basin
    for (final low in lowPoints) {
      final basin = <Position>{};
      final unsearched = <Position>{low};

      // loop to find all points in basin
      while (unsearched.isNotEmpty) {
        // take out of unsearched, write 9 to board and add to basin
        final searchPos = unsearched.last;
        basin.add(searchPos);
        unsearched.remove(searchPos);
        ignorePosition(searchPos);

        final viableNeigh = _neighbours(board, searchPos.item2, searchPos.item1)
            .where((neigh) => board[neigh.item2][neigh.item1] != 9);

        unsearched.addAll(viableNeigh);
      }

      // add basin to basins as soon as all viable pos are visited
      basins.add(basin);
    }

    // sort based on basin size and return the product of the first 3
    final sortedBasins = basins.toList()
      ..sort((b1, b2) => b2.length - b1.length);

    return sortedBasins
        .take(3)
        .fold<int>(1, (prev, basin) => prev * basin.length);
  }

  List<Position> _neighbours(TBoard board, int y, int x) {
    final positions = <Position>[
      Position(x, y - 1),
      Position(x, y + 1),
      Position(x - 1, y),
      Position(x + 1, y),
    ];

    return positions
      ..removeWhere((pos) =>
          pos.item1 < 0 ||
          pos.item2 < 0 ||
          pos.item1 >= board[0].length ||
          pos.item2 >= board.length);
  }
}
