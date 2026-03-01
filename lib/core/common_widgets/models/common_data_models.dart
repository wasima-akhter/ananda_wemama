class IdentityCardDataModel {
  final String title;
  final String phone;
  final String email;
  final String? address;
  final String? imageUrl;
  final String? avgRating;
  final String? totalRating;

  IdentityCardDataModel({
    required this.title,
    required this.phone,
    required this.email,
    this.avgRating,
    this.totalRating,
    this.imageUrl,
    this.address,
  });
}

class SingleOrderDataModel {
  SingleOrderDataModel({
    this.id,
    this.customer,
    this.supplier,
    this.status,
    this.paymentStatus,
    this.paymentReference,
    this.fuelPriceRate,
    this.dieselPriceRate,
    this.fuelQuantity,
    this.dieselQuantity,
    this.fuelPrice,
    this.dieselPrice,
    this.totalPrice,
    this.location,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final dynamic? customer;
  final dynamic supplier;
  final String? status;
  final String? paymentStatus;
  final String? paymentReference;
  final dynamic fuelPriceRate;
  final dynamic dieselPriceRate;
  final dynamic fuelQuantity;
  final dynamic dieselQuantity;
  final dynamic fuelPrice;
  final dynamic dieselPrice;
  final dynamic totalPrice;
  final String? location;
  final String? latitude;
  final String? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic v;

  factory SingleOrderDataModel.fromJson(Map<String, dynamic> json) {
    return SingleOrderDataModel(
      id: json["_id"],
      // Handle both String ID or full object for customer
      customer: json["customer"] == null
          ? null
          : json["customer"] is String
          ? SingleOrderCustomerData(id: json["customer"])
          : SingleOrderCustomerData.fromJson(json["customer"]),

      supplier: json["supplier"] == null
          ? null
          : json["supplier"] is String
          ? SingleOrderSupplierData(id: json["supplier"])
          : SingleOrderSupplierData.fromJson(json["supplier"]),

      status: json["status"],
      paymentStatus: json["paymentStatus"],
      paymentReference: json["paymentReference"],
      fuelPriceRate: json["fuelPriceRate"],
      dieselPriceRate: json["dieselPriceRate"],
      fuelQuantity: json["fuelQuantity"],
      dieselQuantity: json["dieselQuantity"],
      fuelPrice: json["fuelPrice"],
      dieselPrice: json["dieselPrice"],
      totalPrice: json["totalPrice"],
      location: json["location"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"].toString()) : null,

      updatedAt: json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"].toString()) : null,

      v: json["__v"],
    );
  }
}

class SingleOrderCustomerData {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;

  SingleOrderCustomerData({this.id, this.name, this.email, this.phone, this.image});

  factory SingleOrderCustomerData.fromJson(Map<String, dynamic> json) {
    return SingleOrderCustomerData(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      image: json["image"],
    );
  }
}

class SingleOrderSupplierData {
  SingleOrderSupplierData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.averageRating,
    this.totalRating,
    this.address,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final String? address;
  final dynamic averageRating;
  final dynamic totalRating;

  factory SingleOrderSupplierData.fromJson(Map<String, dynamic> json) {
    return SingleOrderSupplierData(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      image: json["image"],
      address: json["address"],
      averageRating: json["averageRating"],
      totalRating: json["totalRating"],
    );
  }
}

class CommonTitleIconpathModel {
  final String title;
  final String? subtitle;
  final String iconPath;

  CommonTitleIconpathModel({required this.title, required this.iconPath, this.subtitle});
}
