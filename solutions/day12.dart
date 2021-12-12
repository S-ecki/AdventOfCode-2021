import 'package:graph_collection/graph.dart';

import '../utils/index.dart';

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  LinkGraph parseInput() {
    final lines = input.getPerLine();
    final graph = LinkGraph();

    for (final line in lines) {
      final nodes = line.trim().split('-');
      graph.link(nodes[0], nodes[1]);
    }
    return graph;
  }

  @override
  int solvePart1() {
    final graph = parseInput();

    return dfs1(graph);
  }

  int dfs1(
    LinkGraph g, {
    Set<String>? visited,
    String start = 'start',
    String end = 'end',
  }) {
    if (start == end) {
      return 1;
    }

    visited = visited ?? Set();

    final lowerString = start.toLowerCase();
    // start was lowercase
    if (lowerString == start) {
      visited.add(start);
    }

    int path_count = 0;
    final links = g.links(start);
    for (final link in links) {
      if (!visited.contains(link)) {
        path_count += dfs1(g, visited: {...visited}, start: link, end: end);
      }
    }

    return path_count;
  }

  int dfs2(
    LinkGraph g, {
    Set<String>? visited,
    String start = 'start',
    String end = 'end',
    bool d = true,
  }) {
    if (start == end) {
      return 1;
    }

    visited = visited ?? Set();

    final lowerString = start.toLowerCase();
    // start was lowercase
    if (lowerString == start) {
      visited.add(start);
    }

    int path_count = 0;
    final links = g.links(start);
    for (final link in links) {
      if (!visited.contains(link)) {
        path_count += dfs2(
          g,
          visited: {...visited},
          start: link,
          end: end,
          d: d,
        );
      } else if (d && link != 'start') {
        path_count += dfs2(
          g,
          visited: {...visited},
          start: link,
          end: end,
          d: false,
        );
        ;
      }
    }

    return path_count;
  }

  @override
  int solvePart2() {
    final graph = parseInput();

    return dfs2(graph);
  }
}
