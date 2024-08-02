class PlaceDetailsModel {
  String placeId;
  String name;
  String formattedAddress;
  String phoneNumber;
  double lat;
  double lng;
  double rating;
  String website;
  List<String> types;

  PlaceDetailsModel({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    required this.phoneNumber,
    required this.lat,
    required this.lng,
    required this.rating,
    required this.website,
    required this.types,
  });

  factory PlaceDetailsModel.fromJson(Map<String, dynamic> json) {
    var result = json['result'];
    // log("result ${jsonEncode(result)}");

    return PlaceDetailsModel(
      placeId: result['place_id'],
      name: result['name'],
      formattedAddress: result['formatted_address'],
      phoneNumber: result['formatted_phone_number'] ?? '',
      lat: result['geometry']['location']['lat'],
      lng: result['geometry']['location']['lng'],
      rating: result['rating']?.toDouble() ?? 0.0,
      website: result['website'] ?? '',
      types: List<String>.from(result['types']),
    );
  }
}
