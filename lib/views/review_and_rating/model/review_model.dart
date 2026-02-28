class AllReviewsResponseModel {
  AllReviewsResponseModel({this.allReviews, this.result});

  final List<AllReview>? allReviews;
  final List<Result>? result;

  factory AllReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    return AllReviewsResponseModel(
      allReviews: json["allReviews"] == null
          ? []
          : List<AllReview>.from(json["allReviews"]!.map((x) => AllReview.fromJson(x))),
      result: json["result"] == null
          ? []
          : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    );
  }
}

class AllReview {
  AllReview({
    this.id,
    this.supplier,
    this.reviewerName,
    this.description,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? supplier;
  final String? reviewerName;
  final String? description;
  final dynamic rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic v;

  factory AllReview.fromJson(Map<String, dynamic> json) {
    return AllReview(
      id: json["_id"],
      supplier: json["supplier"],
      reviewerName: json["reviewerName"],
      description: json["description"],
      rating: json["rating"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}

class Result {
  Result({this.totalReviews, this.averageRating, this.starWise});

  final dynamic totalReviews;
  final dynamic averageRating;
  final StarWise? starWise;

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      totalReviews: json["totalReviews"],
      averageRating: json["averageRating"],
      starWise: json["starWise"] == null ? null : StarWise.fromJson(json["starWise"]),
    );
  }
}

class StarWise {
  StarWise({this.the1Star, this.the2Star, this.the3Star, this.the4Star, this.the5Star});

  final dynamic the1Star;
  final dynamic the2Star;
  final dynamic the3Star;
  final dynamic the4Star;
  final dynamic the5Star;

  factory StarWise.fromJson(Map<String, dynamic> json) {
    return StarWise(
      the1Star: json["1_star"],
      the2Star: json["2_star"],
      the3Star: json["3_star"],
      the4Star: json["4_star"],
      the5Star: json["5_star"],
    );
  }
}
