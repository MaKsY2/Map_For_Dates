class Placemarks {
  List<Placemark>? placemark;

  Placemarks({this.placemark});

  Placemarks.fromJson(Map<String, dynamic> json) {
    if (json['placemark'] != null) {
      placemark = <Placemark>[];
      json['placemark'].forEach((v) {
        placemark!.add(new Placemark.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.placemark != null) {
      data['placemark'] = this.placemark!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Placemark {
  String? date;
  int? id;
  double? latitude;
  double? longitude;
  int? poseId;
  int? quality;
  String? text;
  int? userId;
  String? name;

  Placemark(
      {this.date,
        this.id,
        this.latitude,
        this.longitude,
        this.poseId,
        this.quality,
        this.text,
        this.userId,
        this.name});

  Placemark.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    poseId = json['pose_id'];
    quality = json['quality'];
    text = json['text'];
    userId = json['user_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['pose_id'] = this.poseId;
    data['quality'] = this.quality;
    data['text'] = this.text;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    return data;
  }
}