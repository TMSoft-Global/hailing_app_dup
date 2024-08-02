class RidePickUpModel {
  PickUpStut? pickup;
  PickUpStut? whereTo;
  List<PickUpStut>? busStops;

  RidePickUpModel({this.pickup, this.whereTo, this.busStops});

  RidePickUpModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      pickup = json['pickup'] != null
          ? new PickUpStut.fromJson(json['pickup'])
          : null;
      whereTo = json['whereTo'] != null
          ? new PickUpStut.fromJson(json['whereTo'])
          : null;
      if (json['busStops'] != null) {
        busStops = <PickUpStut>[];
        json['busStops'].forEach((v) {
          busStops!.add(new PickUpStut.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pickup != null) {
      data['pickup'] = pickup!.toJson();
    }
    if (whereTo != null) {
      data['whereTo'] = whereTo!.toJson();
    }
    if (busStops != null) {
      data['busStops'] = busStops!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PickUpStut {
  String? name;
  double? long;
  double? lat;

  PickUpStut({this.name, this.long, this.lat});

  PickUpStut.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    long = double.parse(json['long'].toString());
    lat = double.parse(json['lat'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['long'] = long;
    data['lat'] = lat;
    return data;
  }
}
