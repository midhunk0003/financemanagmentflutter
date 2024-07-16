import 'package:hive_flutter/adapters.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  late String? email;
  @HiveField(1)
  late String? password;
  @HiveField(2)
  late String? name;
  @HiveField(3)
  late String? phone;
  @HiveField(4)
  late int? status;
  @HiveField(5)
  late int? id;

  UserModel(
      {this.email, this.password, this.name, this.phone, this.status, this.id});

  @override
  String toString() {
    return 'UserModel : {id: $id,email : $email,password : $password , name : $name , phone : $phone , status : $status}';
  }
}
