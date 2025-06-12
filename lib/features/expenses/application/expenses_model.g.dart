// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseItemAdapter extends TypeAdapter<ExpenseItem> {
  @override
  final int typeId = 6;

  @override
  ExpenseItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseItem(
      name: fields[0] as String,
      amount: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenseListAdapter extends TypeAdapter<ExpenseList> {
  @override
  final int typeId = 7;

  @override
  ExpenseList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseList(
      title: fields[0] as String,
      items: (fields[1] as List).cast<ExpenseItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
