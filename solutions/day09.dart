import '../utils/index.dart';

typedef Basin = Set<Position>;

class Day09 extends GenericDay {
  Day09() : super(9);

  final lowPoints = <Position>[];

  @override
  Field<int> parseInput() {
    return Field<int>(input
        .getPerLine()
        .map((e) => ParseUtil.stringListToIntList(e.trim().split('')))
        .toList());
  }

  @override
  int solvePart1() {
    final board = parseInput();

    // checks if any neighbour has lower value
    // if not, appends it to lowpoints
    board.forEach((x, y) {
      if (board
          .adjacent(x, y)
          .where((n) => board.getValueAt(n.x, n.y) <= board.getValueAt(x, y))
          .isEmpty) {
        lowPoints.add(Tuple2(x, y));
      }
    });

    final lowestValues =
        lowPoints.map<int>((e) => board.getValueAt(e.x, e.y)).toList();
    return lowestValues.fold<int>(0, (prev, val) => prev += val + 1);
  }

  @override
  int solvePart2() {
    final board = parseInput();
    final basins = <Basin>{};

    // done to disregard that pos, as 9s are not taken into account
    final ignorePosition = (Position pos) => board.setValueAt(pos.x, pos.y, 9);

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

        final viableNeigh = board
            .adjacent(searchPos.x, searchPos.y)
            .where((neigh) => board.getValueAt(neigh.x, neigh.y) != 9);

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
}
