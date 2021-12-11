import 'package:tuple/tuple.dart';

typedef Board = List<List<int>>;
typedef Position = Tuple2<int, int>;
typedef Basin = Set<Position>;
typedef StringList = List<String>;
typedef Command = Tuple2<StringList, StringList>;
typedef VoidBoardCallback = void Function(int, int);
