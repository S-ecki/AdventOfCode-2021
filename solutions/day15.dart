import 'package:dijkstra/dijkstra.dart';

import '../utils/index.dart';

class Day15 extends GenericDay {
  Day15() : super(15);

  @override
  Field<int> parseInput() {
    return IntegerField.fromString(input.asString);
  }

  @override
  int solvePart1() {
    final field = parseInput();
    final graph = Map<Position, Map<Position, int>>();

    // fill graph with all possible paths
    field.forEach((x, y) {
      final adj = field.adjacent(x, y);
      final entries = adj.map((p) => MapEntry(p, field.getValueAtPosition(p)));
      graph[Position(x, y)] = Map.fromEntries(entries);
    });

    final start = Position(0, 0);
    final end = Position(field.height - 1, field.width - 1);

    // skip first pos as cost only counts when entering new position
    final path = Dijkstra.findPathFromGraph(graph, start, end).skip(1);

    return path.fold<int>(
        0, (prev, pos) => prev + field.getValueAtPosition(pos));
  }

  @override
  int solvePart2() {
    final field = parseInput();
    final height = field.height;
    final width = field.width;

    final graph = Map<Position, Map<Position, int>>();

    for (var xx = 0; xx < 5; xx++) {
      for (var yy = 0; yy < 5; yy++) {
        field.forEach((x, y) {
          // add all adjacent positions
          final adj = field.adjacent(x, y).toSet();
          graph[Position(x + xx * width, y + yy * height)] = Map.fromEntries(
              adj.map((p) => MapEntry(
                  Position(p.x + xx * width, p.y + yy * height),
                  ((field.getValueAt(p.x, p.y) + xx + yy) - 1) % 9 + 1)));
          // add connections to the right
          if (x == width - 1 && xx != 4) {
            graph[Position(x + xx * width, y + yy * height)]!.addEntries([
              MapEntry(Position(x + xx * width + 1, y + yy * height),
                  ((field.getValueAt(0, y) + xx + yy + 1) - 1) % 9 + 1)
            ]);
          }
          // add connections to the left
          else if (x == 0 && xx != 0) {
            graph[Position(x + xx * width, y + yy * height)]!.addEntries([
              MapEntry(Position(x + xx * width - 1, y + yy * height),
                  ((field.getValueAt(width - 1, y) + xx + yy - 1) - 1) % 9 + 1)
            ]);
          }
          // add connections to the bottom
          else if (y == height - 1 && yy != 4) {
            graph[Position(x + xx * width, y + yy * height)]!.addEntries([
              MapEntry(Position(x + xx * width, y + yy * height + 1),
                  ((field.getValueAt(x, 0) + xx + yy + 1) - 1) % 9 + 1)
            ]);
          }
          // add connections to the top
          else if (y == 0 && yy != 0) {
            graph[Position(x + xx * width, y + yy * height)]!.addEntries([
              MapEntry(Position(x + xx * width, y + yy * height - 1),
                  ((field.getValueAt(x, height - 1) + xx + yy - 1) - 1) % 9 + 1)
            ]);
          }
        });
      }
    }

    final start = Position(0, 0);
    final end = Position(width * 5 - 1, height * 5 - 1);

    final path = Dijkstra.findPathFromGraph(graph, start, end);

    int cost = 0;
    for (var i = 0; i < path.length - 1; ++i) {
      cost += graph.costForMove(path[i], path[i + 1]);
    }
    return cost;
  }
}

extension on Map<Position, Map<Position, int>> {
  int costForMove(Position from, Position to) {
    return this[from]![to]!;
  }
}
