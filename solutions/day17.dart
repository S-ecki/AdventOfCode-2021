import '../utils/index.dart';

typedef Target = Tuple4<int, int, int, int>;

class Day17 extends GenericDay {
  Day17() : super(17);

  /// Holds all velocities that reach the target in any amount of steps
  final startVelocities = <Position>{};

  @override
  Target parseInput() {
    var s = input.asString;
    // remove everything prior to first coordinate
    s = s.replaceRange(0, s.indexOf('x'), '');
    // remove all non-numberic characters and add , between coordinates
    s = s.replaceAllMapped(RegExp(r'(\s?(x|y)=)'), (match) => '');
    s = s.replaceAllMapped(('..'), (match) => ',');
    // create list of coordinates
    final coordinates = s.split(',').map((s) => int.parse(s)).toList();

    return Target.fromList(coordinates);
  }

  @override
  int solvePart1() {
    final target = parseInput();

    // loop over space of possible velocities that could reach target
    for (var x = 22; x <= target.x2; x++) {
      for (var y = target.y1; y <= target.y1.abs(); y++) {
        final velocity = Position(x, y);
        if (probeReachesTarget(velocity, target)) {
          startVelocities.add(velocity);
        }
      }
    }
    final maxVelocity = max<Position>(startVelocities, (v1, v2) => v1.y - v2.y);

    return maxHeight(maxVelocity!.y);
  }

  @override
  int solvePart2() {
    return startVelocities.length;
  }

  bool probeReachesTarget(Position velocity, Target target) {
    var position = Position(0, 0);
    // while the target is not overshot by position
    while (position.x <= target.x2 && position.y >= target.y1) {
      // calculate new position from velocity
      position = Position(position.x + velocity.x, position.y + velocity.y);
      // explicit break if on target
      if (target.x1 <= position.x &&
          position.x <= target.x2 &&
          target.y1 <= position.y &&
          position.y <= target.y2) {
        return true;
      }
      // recalculate velocity
      velocity = Position(velocity.x <= 0 ? 0 : velocity.x - 1, velocity.y - 1);
    }
    return false;
  }

  int maxHeight(int velocityY) {
    var positionY = 0;
    while (velocityY > 0) {
      positionY += velocityY;
      velocityY--;
    }
    return positionY;
  }
}

/// 1 stands for min, 2 for max
extension on Target {
  int get x1 => item1;
  int get x2 => item2;
  int get y1 => item3;
  int get y2 => item4;
}
