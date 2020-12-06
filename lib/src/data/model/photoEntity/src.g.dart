// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'src.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SrcAdapter extends TypeAdapter<Src> {
  @override
  final int typeId = 2;

  @override
  Src read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Src(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Src obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.original)
      ..writeByte(1)
      ..write(obj.large2x)
      ..writeByte(2)
      ..write(obj.large)
      ..writeByte(3)
      ..write(obj.medium)
      ..writeByte(4)
      ..write(obj.small)
      ..writeByte(5)
      ..write(obj.portrait)
      ..writeByte(6)
      ..write(obj.landscape)
      ..writeByte(7)
      ..write(obj.tiny);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SrcAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
