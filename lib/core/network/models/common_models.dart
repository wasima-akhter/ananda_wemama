import 'package:mama_app/core/enums/app_enums.dart';

class User {
  final String name;
  final String email;
  final String phone;
  final String role;

  User({required this.name, required this.email, required this.phone, required this.role});

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    role: json['role'] ?? '',
  );
}

//////////////////////////
/// In App custome made models
class CustomerOrderDetailsArg_Model {
  final String customerOrderId;
  final CustomerOrderCategory orderStatus;

  CustomerOrderDetailsArg_Model({required this.customerOrderId, required this.orderStatus});
}

class SupplierOrderDetailsArg_Model {
  final String supplierOrderId;
  final CustomerOrderCategory orderStatus;

  SupplierOrderDetailsArg_Model({required this.supplierOrderId, required this.orderStatus});
}
