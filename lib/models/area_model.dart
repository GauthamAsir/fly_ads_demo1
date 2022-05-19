class AreaModel {
  String? name, id;
  bool? enabled;
  num? screenCount, views;

  AreaModel({this.name, this.enabled, this.id, this.screenCount, this.views});

  static AreaModel fromMap(Map<String, dynamic> map) {
    return AreaModel(
        enabled: map['enabled'],
        id: map['id'],
        name: map['name'],
        screenCount: map['screens_count'],
        views: map['views']);
  }
}
