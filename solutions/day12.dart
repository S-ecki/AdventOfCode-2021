import 'package:graph_collection/graph.dart';

import '../utils/index.dart';

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  LinkGraph parseInput() {
    final lines = input.getPerLine();
    final graph = LinkGraph();

    lines.forEach((line) {
      final nodes = line.trim().split('-');
      graph.link(nodes[0], nodes[1]);
    });
    return graph;
  }

  @override
  int solvePart1() {
    final graph = parseInput();
    return dfs(graph, doubleVisit: false);
  }

  @override
  int solvePart2() {
    final graph = parseInput();
    return dfs(graph);
  }

  int dfs(
    LinkGraph graph, {
    Set<String>? visited,
    String start = 'start',
    String end = 'end',
    bool doubleVisit = true,
  }) {
    if (start == end) return 1;

    visited = visited ?? Set();

    // if it was actually lowercase
    if (start.toLowerCase() == start) visited.add(start);

    int pathCount = 0;

    for (final link in graph.links(start)) {
      if (!visited.contains(link)) {
        pathCount += dfs(
          graph,
          visited: {...visited},
          start: link,
          end: end,
          doubleVisit: doubleVisit,
        );
      } else if (doubleVisit && link != 'start') {
        pathCount += dfs(
          graph,
          visited: {...visited},
          start: link,
          end: end,
          doubleVisit: false,
        );
        ;
      }
    }

    return pathCount;
  }
}
