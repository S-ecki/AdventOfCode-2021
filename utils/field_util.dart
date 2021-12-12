import 'package:quiver/iterables.dart';
import 'package:tuple/tuple.dart';

typedef VoidFieldCallback = void Function(int, int);
typedef Coordinate = Tuple2<int, int>;

extension on Coordinate {
  int get x => item1;
  int get y => item2;
}

// TODO: refactor

/// ! This is a work in progress.
class Field<T> {
  Field(this._board)
      : assert(_board.length > 0),
        assert(_board[0].length > 0),
        height = _board.length,
        width = _board[0].length;

  final List<List<T>> _board;
  final int height;
  final int width;

  T getValue(Coordinate coord) => _board[coord.y][coord.x];

  void setValue(Coordinate coord, T value) => _board[coord.y][coord.x] = value;

  bool isOnField(Coordinate coord) =>
      coord.x >= 0 && coord.y >= 0 && coord.x < width && coord.y < height;

  Iterable<T> getRow(int row) => _board[row];

  Iterable<T> getColumn(int column) => _board.map((row) => row[column]);

  T get maxValue => max<T>(
        _board.reduce((accumulator, list) => [...accumulator, ...list]),
      )!;

  T get minValue => min<T>(
        _board.reduce((accumulator, list) => [...accumulator, ...list]),
      )!;

  void forBoard(VoidFieldCallback callback) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        callback(x, y);
      }
    }
  }

  /// Returns all adjacent cells to the given coord. This does `NOT` include
  /// diagonal neighbours.
  Iterable<Coordinate> adjacent(Coordinate coord) {
    final coords = <Coordinate>{
      Coordinate(coord.x, coord.y - 1),
      Coordinate(coord.x, coord.y + 1),
      Coordinate(coord.x - 1, coord.y),
      Coordinate(coord.x + 1, coord.y),
    };

    return coords
      ..removeWhere(
          (pos) => pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height);
  }

  /// Returns all positional neighbours of a point. This includes the adjacent
  /// `AND` diagonal neighbours.
  Iterable<Coordinate> neighboards(int x, int y) {
    final coords = <Coordinate>{};
    for (var xx = x - 1; xx <= x + 1; ++xx) {
      for (var yy = y - 1; yy <= y + 1; ++yy) {
        if (xx >= 0 &&
            yy >= 0 &&
            (yy != y || xx != x) &&
            xx < width &&
            yy < height) {
          coords.add(Coordinate(xx, yy));
        }
      }
    }
    return coords;
  }
}
