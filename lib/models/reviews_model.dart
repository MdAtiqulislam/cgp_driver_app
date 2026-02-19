class ReviewsModel {
  final Given? given;
  final Given? received;

  ReviewsModel({
    this.given,
    this.received,
  });

  factory ReviewsModel.fromJson(Map<String, dynamic> json) => ReviewsModel(
    given: json["given"] == null ? null : Given.fromJson(json["given"]),
    received: json["received"] == null ? null : Given.fromJson(json["received"]),
  );

  Map<String, dynamic> toJson() => {
    "given": given?.toJson(),
    "received": received?.toJson(),
  };
}

class Given {
  final int? id;
  final int? rating;
  final String? review;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Given({
    this.id,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
  });

  factory Given.fromJson(Map<String, dynamic> json) => Given(
    id: json["id"],
    rating: json["rating"],
    review: json["review"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rating": rating,
    "review": review,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}