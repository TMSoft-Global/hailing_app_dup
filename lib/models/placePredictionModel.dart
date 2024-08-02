class PlacePredictionModel {
  String description;
  String placeId;
  String reference;
  List<String> types;
  int distanceMeters;

  PlacePredictionModel({
    required this.description,
    required this.placeId,
    required this.reference,
    required this.types,
    required this.distanceMeters,
  });

  factory PlacePredictionModel.fromJson(Map<String, dynamic> json) {
    return PlacePredictionModel(
      description: json['description'],
      placeId: json['place_id'],
      reference: json['reference'] ?? '',
      types: List<String>.from(json['types']),
      distanceMeters: json['distance_meters'] ?? 0,
    );
  }
}
