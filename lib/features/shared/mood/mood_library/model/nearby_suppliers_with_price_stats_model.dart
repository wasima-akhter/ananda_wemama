class NearbySuppliersPriceDataModel {
  NearbySuppliersPriceDataModel({this.suppliers, this.stats, this.count, this.searchedFrom});

  final List<NearestSupplierDataModel>? suppliers;
  final Stats? stats;
  final int? count;
  final SearchedFrom? searchedFrom;

  factory NearbySuppliersPriceDataModel.fromJson(Map<String, dynamic> json) {
    return NearbySuppliersPriceDataModel(
      suppliers: json["suppliers"] == null
          ? []
          : List<NearestSupplierDataModel>.from(
              json["suppliers"]!.map((x) => NearestSupplierDataModel.fromJson(x)),
            ),
      stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
      count: json["count"],
      searchedFrom: json["searchedFrom"] == null
          ? null
          : SearchedFrom.fromJson(json["searchedFrom"]),
    );
  }
}

class SearchedFrom {
  SearchedFrom({this.latitude, this.longitude, this.radiusKm});

  final String? latitude;
  final String? longitude;
  final String? radiusKm;

  factory SearchedFrom.fromJson(Map<String, dynamic> json) {
    return SearchedFrom(
      latitude: json["latitude"],
      longitude: json["longitude"],
      radiusKm: json["radiusKm"],
    );
  }
}

class Stats {
  Stats({this.count, this.fuel, this.diesel});

  final int? count;
  final Diesel? fuel;
  final Diesel? diesel;

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      count: json["count"],
      fuel: json["fuel"] == null ? null : Diesel.fromJson(json["fuel"]),
      diesel: json["diesel"] == null ? null : Diesel.fromJson(json["diesel"]),
    );
  }
}

class Diesel {
  Diesel({this.min, this.max});

  final Max? min;
  final Max? max;

  factory Diesel.fromJson(Map<String, dynamic> json) {
    return Diesel(
      min: json["min"] == null ? null : Max.fromJson(json["min"]),
      max: json["max"] == null ? null : Max.fromJson(json["max"]),
    );
  }
}

class Max {
  Max({this.rate, this.supplierName, this.supplierId});

  final dynamic? rate;
  final String? supplierName;
  final String? supplierId;

  factory Max.fromJson(Map<String, dynamic> json) {
    return Max(
      rate: json["rate"],
      supplierName: json["supplierName"],
      supplierId: json["supplierId"],
    );
  }
}

class NearestSupplierDataModel {
  NearestSupplierDataModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.todayFuelRate,
    this.todayDieselRate,
    this.todayFuelStock,
    this.todayDieselStock,
    this.isApproved,
    this.averageRating,
    this.totalRating,
    this.address,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final dynamic todayFuelRate;
  final dynamic todayDieselRate;
  final dynamic todayFuelStock;
  final dynamic todayDieselStock;
  final bool? isApproved;
  final dynamic averageRating;
  final int? totalRating;
  final String? address;

  factory NearestSupplierDataModel.fromJson(Map<String, dynamic> json) {
    return NearestSupplierDataModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      image: json["image"],
      todayFuelRate: json["todayFuelRate"],
      todayDieselRate: json["todayDieselRate"],
      todayFuelStock: json["todayFuelStock"],
      todayDieselStock: json["todayDieselStock"],
      isApproved: json["isApproved"],
      averageRating: json["averageRating"],
      totalRating: json["totalRating"],
      address: json["address"],
    );
  }
}
