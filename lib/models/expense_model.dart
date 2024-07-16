import 'package:hive_flutter/adapters.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 2)
class ExpenseModel {
  @HiveField(0)
  late int? id;
  @HiveField(1)
  late int? userid;
  @HiveField(2)
  late double? amount;
  @HiveField(3)
  late String? description;
  @HiveField(4)
  late String? category;
  @HiveField(5)
  late DateTime? createdAt;

  ExpenseModel(
      {this.id,
      this.userid,
      this.amount,
      this.category,
      this.description,
      this.createdAt});

  @override
  String toString() {
    return 'ExpenseModel : {id: $id,userid : $userid,amount : $amount , description : $description , category : $category, dateTime : $createdAt}';
  }
}
