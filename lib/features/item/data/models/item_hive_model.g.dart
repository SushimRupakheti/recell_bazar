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
      phoneModel: fields[5] as String,
      year: fields[6] as int,
      batteryHealth: fields[7] as int,
      description: fields[8] as String,
      deviceCondition: fields[9] as String,
      chargerAvailable: fields[10] as bool,
      factoryUnlock: fields[11] as bool,
      liquidDamage: fields[12] as bool,
      switchOn: fields[13] as bool,
      receiveCall: fields[14] as bool,
      features1Condition: fields[15] as bool,
      features2Condition: fields[16] as bool,
      cameraCondition: fields[17] as bool,
      displayCondition: fields[18] as bool,
      displayCracked: fields[19] as bool,
      displayOriginal: fields[20] as bool,
      createdAt: fields[21] as DateTime?,
      updatedAt: fields[22] as DateTime?,
      isSold: fields[23] as bool,
      finalPrice: fields[24] as String,
      basePrice: fields[25] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItemHiveModel obj) {
    writer
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
      ..write(obj.phoneModel)
      ..writeByte(6)
      ..write(obj.year)
      ..writeByte(7)
      ..write(obj.batteryHealth)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.deviceCondition)
      ..writeByte(10)
      ..write(obj.chargerAvailable)
      ..writeByte(11)
      ..write(obj.factoryUnlock)
      ..writeByte(12)
      ..write(obj.liquidDamage)
      ..writeByte(13)
      ..write(obj.switchOn)
      ..writeByte(14)
      ..write(obj.receiveCall)
      ..writeByte(15)
      ..write(obj.features1Condition)
      ..writeByte(16)
      ..write(obj.features2Condition)
      ..writeByte(17)
      ..write(obj.cameraCondition)
      ..writeByte(18)
      ..write(obj.displayCondition)
      ..writeByte(19)
      ..write(obj.displayCracked)
      ..writeByte(20)
      ..write(obj.displayOriginal)
      ..writeByte(21)
      ..write(obj.createdAt)
      ..writeByte(22)
      ..write(obj.updatedAt)
      ..writeByte(23)
      ..write(obj.isSold)
      ..writeByte(24)
      ..write(obj.finalPrice)
      ..writeByte(25)
      ..write(obj.basePrice);
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
