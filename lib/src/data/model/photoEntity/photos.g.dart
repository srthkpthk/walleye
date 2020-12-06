// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotosAdapter extends TypeAdapter<Photos> {
  @override
  final int typeId = 1;

  @override
  Photos read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Photos(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
    )..src = fields[3] as Src;
  }

  @override
  void write(BinaryWriter writer, Photos obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.photographer)
      ..writeByte(3)
      ..write(obj.src);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotosAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
