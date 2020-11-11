import 'package:hive/hive.dart';
part 'bp.g.dart';

@HiveType(typeId: 1)
class Bp {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  int systolic;

  @HiveField(2)
  int diastolic;

  @HiveField(3)
  int pulse;
}
