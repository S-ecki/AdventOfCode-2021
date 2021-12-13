import 'package:quiver/iterables.dart';
import 'package:tuple/tuple.dart';

typedef Position = Tuple2<int, int>;
typedef VoidFieldCallback = void Function(int, int);

// TODO: refactor
// TODO: rename positioninate to position

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

  T getValueAt(int x, int y) => _board[y][x];
  T getValueAtPosition(Position position) => _board[position.y][position.x];

  setValueAtPosition(Position position, T value) =>
      _board[position.y][position.x] = value;
  setValueAt(int x, int y, T value) => _board[y][x] = value;

  bool isOnField(Position position) =>
      position.x >= 0 &&
      position.y >= 0 &&
      position.x < width &&
      position.y < height;

  Iterable<T> getRow(int row) => _board[row];

  Iterable<T> getColumn(int column) => _board.map((row) => row[column]);

  T get maxValue => max<T>(
        _board.reduce((accumulator, list) => [...accumulator, ...list]),
      )!;

  T get minValue => min<T>(
        _board.reduce((accumulator, list) => [...accumulator, ...list]),
      )!;

  forEach(VoidFieldCallback callback) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        callback(x, y);
      }
    }
  }

  forCoordinates(
    Iterable<Position> positioninates,
    VoidFieldCallback callback,
  ) {
    positioninates.forEach((position) => callback(position.x, position.y));
  }

  /// TODO: refactor
  /// Returns all adjacent cells to the given position. This does `NOT` include
  /// diagonal neighbours.
  Iterable<Position> adjacent(int x, int y) {
    final positions = <Position>{
      Position(x, y - 1),
      Position(x, y + 1),
      Position(x - 1, y),
      Position(x + 1, y),
    };

    return positions
      ..removeWhere(
          (pos) => pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height);
  }

  /// TODO: refactor
  /// Returns all positional neighbours of a point. This includes the adjacent
  /// `AND` diagonal neighbours.
  Iterable<Position> neighbours(int x, int y) {
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

extension Incrementor on Field<int> {
  increment(int x, int y) => this.setValueAt(x, y, this.getValueAt(x, y) + 1);
}

extension CoordinateLocator on Position {
  int get x => item1;
  int get y => item2;
}
