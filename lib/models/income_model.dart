import 'package:hive_flutter/adapters.dart';
part 'income_model.g.dart';

@HiveType(typeId: 1)
class IncomeModel {
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

  IncomeModel(
      {this.id, this.userid, this.amount, this.category, this.description,this.createdAt});

  @override
  String toString() {
    return 'IncomeModel : {id: $id,userid : $userid,amount : $amount , description : $description , category : $category, dateTime : $createdAt}';
  }
}
