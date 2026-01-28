// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemHiveModelAdapter extends TypeAdapter<ItemHiveModel> {
  @override
  final int typeId = 0;

  @override
  ItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemHiveModel(
      itemId: fields[0] as String?,
      sellerId: fields[1] as String,
      seller: fields[2] as String,
      photos: (fields[3] as List).cast<String>(),
      category: fields[4] as String,
      model: fields[5] as String,
      price: fields[6] as double,
      year: fields[7] as int,
      description: fields[8] as String,
      storage: fields[9] as String,
      screenCondition: fields[10] as String,
      batteryHealth: fields[11] as int,
      cameraQuality: fields[12] as String,
      hasCharger: fields[13] as bool,
      extraAnswers: (fields[14] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[15] as DateTime?,
      updatedAt: fields[16] as DateTime?, isSold: false,
    );
  }

  @override
  void write(BinaryWriter writer, ItemHiveModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.sellerId)
      ..writeByte(2)
      ..write(obj.seller)
      ..writeByte(3)
      ..write(obj.photos)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.model)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.year)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.storage)
      ..writeByte(10)
      ..write(obj.screenCondition)
      ..writeByte(11)
      ..write(obj.batteryHealth)
      ..writeByte(12)
      ..write(obj.cameraQuality)
      ..writeByte(13)
      ..write(obj.hasCharger)
      ..writeByte(14)
      ..write(obj.extraAnswers)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
