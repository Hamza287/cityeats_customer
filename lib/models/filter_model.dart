class FilterModel {
  String sortBy;
  double minPrice;
  double maxPrice;
  double minRating;
  double maxRating;
  double minDistance;
  double maxDistance;
  bool isPriceRange;
  List<String> offers;

  FilterModel({
    required this.sortBy,
    required this.minPrice,
    required this.maxPrice,
    required this.minRating,
    required this.maxRating,
    required this.maxDistance,
    required this.minDistance,
    required this.offers,
    required this.isPriceRange,
  });
}
