// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BpAdapter extends TypeAdapter<Bp> {
  @override
  final int typeId = 1;

  @override
  Bp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bp(
      fields[0] as DateTime,
      fields[1] as int,
      fields[2] as int,
      fields[3] as int,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Bp obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.systolic)
      ..writeByte(2)
      ..write(obj.diastolic)
      ..writeByte(3)
      ..write(obj.pulse)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BpAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
