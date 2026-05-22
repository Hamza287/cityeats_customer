class FilterBody {
  String? category;
  double? minPrice;
  double? maxPrice;
  double? minDistance;
  double? maxDistance;
  double? minRating;
  double? maxRating;
  double? lat;
  double? lng;

  FilterBody({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minDistance,
    this.maxDistance,
    this.minRating,
    this.maxRating,
    this.lat,
    this.lng,
  });

  factory FilterBody.fromJson(Map<String, dynamic> json) {
    return FilterBody(
      category: json['category'],
      minPrice: json['minPrice'].toDouble(),
      maxPrice: json['maxPrice'].toDouble(),
      minDistance: json['minDistance'].toDouble(),
      maxDistance: json['maxDistance'].toDouble(),
      minRating: json['minRating'].toDouble(),
      maxRating: json['maxRating'].toDouble(),
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'min_price': minPrice,
      'max_price': maxPrice,
      'min_distance': minDistance,
      'max_distance': maxDistance,
      'min_rating': minRating,
      'max_rating': maxRating,
      'lat': lat,
      'lng': lng,
    };
  }
}
