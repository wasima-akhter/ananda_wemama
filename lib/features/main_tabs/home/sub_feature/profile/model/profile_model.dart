class ProfileDataModel {
  ProfileDataModel({
    this.id,
    this.user,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.address,
    this.latitude,
    this.longitude,
    this.document,
    this.todayFuelRate,
    this.todayDieselRate,
    this.todayFuelLoad,
    this.previousDayFuelLoadRemain,
    this.todayCompletedFuelDelivery,
    this.todayReservedFuelForDelivery,
    this.todayFuelStock,
    this.todayDieselLoad,
    this.previousDayDieselLoadRemain,
    this.todayCompletedDieselDelivery,
    this.todayReservedDieselForDelivery,
    this.todayDieselStock,
    this.bankName,
    this.accountName,
    this.accountNumber,
    this.isApproved,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.averageRating,
    this.totalRating,
    this.location,
  });

  final String? id;
  final String? user;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final String? address;
  final LocationCordsDataModel? location;
  final String? latitude;
  final String? longitude;
  final String? document;
  final dynamic todayFuelRate;
  final dynamic todayDieselRate;
  final dynamic todayFuelLoad;
  final dynamic previousDayFuelLoadRemain;
  final dynamic todayCompletedFuelDelivery;
  final dynamic todayReservedFuelForDelivery;
  final dynamic todayFuelStock;
  final dynamic todayDieselLoad;
  final dynamic previousDayDieselLoadRemain;
  final dynamic todayCompletedDieselDelivery;
  final dynamic todayReservedDieselForDelivery;
  final dynamic todayDieselStock;
  final String? bankName;
  final String? accountName;
  final String? accountNumber;
  final bool? isApproved;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic averageRating;
  final dynamic totalRating;
  final dynamic v;

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileDataModel(
      id: json["_id"],
      user: json["user"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      image: json["image"],
      address: json["address"].toString(),
      location: json["location"] == null ? null : LocationCordsDataModel.fromJson(json["location"]),
      latitude: json["latitude"],
      longitude: json["longitude"],
      document: json["document"],
      todayFuelRate: json["todayFuelRate"],
      todayDieselRate: json["todayDieselRate"],
      todayFuelLoad: json["todayFuelLoad"],
      previousDayFuelLoadRemain: json["previousDayFuelLoadRemain"],
      todayCompletedFuelDelivery: json["todayCompletedFuelDelivery"],
      todayReservedFuelForDelivery: json["todayReservedFuelForDelivery"],
      todayFuelStock: json["todayFuelStock"],
      todayDieselLoad: json["todayDieselLoad"],
      previousDayDieselLoadRemain: json["previousDayDieselLoadRemain"],
      todayCompletedDieselDelivery: json["todayCompletedDieselDelivery"],
      todayReservedDieselForDelivery: json["todayReservedDieselForDelivery"],
      todayDieselStock: json["todayDieselStock"],
      bankName: json["bankName"],
      accountName: json["accountName"],
      accountNumber: json["accountNumber"],
      isApproved: json["isApproved"],

      averageRating: json["averageRating"],
      totalRating: json["totalRating"],

      createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"].toString()) : null,

      updatedAt: json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"].toString()) : null,
      v: json["__v"],
    );
  }
}

class LocationCordsDataModel {
  LocationCordsDataModel({this.type, this.coordinates});

  final String? type;
  final List<double>? coordinates;

  factory LocationCordsDataModel.fromJson(Map<String, dynamic> json) {
    return LocationCordsDataModel(
      type: json["type"],
      coordinates: json["coordinates"] == null
          ? []
          : List<double>.from(json["coordinates"]!.map((x) => x)),
    );
  }
}
