class AvgRating {
  final dynamic averageRating;
  final dynamic totalRatings;

  AvgRating({
    this.averageRating,
    this.totalRatings,
  });

  factory AvgRating.fromJson(Map<String, dynamic> json) => AvgRating(
    averageRating: json["average_rating"],
    totalRatings: json["total_ratings"],
  );

  Map<String, dynamic> toJson() => {
    "average_rating": averageRating,
    "total_ratings": totalRatings,
  };
}