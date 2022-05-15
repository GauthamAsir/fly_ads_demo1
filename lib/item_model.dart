import 'package:latlng/latlng.dart';

class ItemModel {
  String name = '', description = '', image = '';
  LatLng latLng;
  DateTime activeFrom;
  bool isActive;

  ItemModel({
    required this.name,
    required this.description,
    required this.image,
    required this.latLng,
    required this.activeFrom,
    required this.isActive,
  });
}
