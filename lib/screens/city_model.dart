import 'package:fly_ads_demo1/item_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CityModel {
  String name = '', description = '', image = '';
  List<ItemModel>? items;

  CityModel(
      {required this.name,
      required this.description,
      required this.image,
      this.items});

}
