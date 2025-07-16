// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MarkerModelAdapter extends TypeAdapter<MarkerModel> {
  @override
  final int typeId = 0;

  @override
  MarkerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MarkerModel(
      id: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      title: fields[3] as String,
      description: fields[4] as String?,
      createdAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MarkerModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
