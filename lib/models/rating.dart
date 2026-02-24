class Rating {
  final int id;
  final double rating;
  final String comment;
  final String ratedBy;
  final String ratedAt;

  Rating({
    required this.id,
    required this.rating,
    required this.comment,
    required this.ratedBy,
    required this.ratedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      ratedBy: json['rated_by'],
      ratedAt: json['rated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'rated_by': ratedBy,
      'rated_at': ratedAt,
    };
  }
}
