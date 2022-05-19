import 'package:fly_ads_demo1/models/item_model.dart';

class CityModel {
  String name = '', description = '', image = '';
  List<ItemModel>? items;

  CityModel(
      {required this.name,
      required this.description,
      required this.image,
      this.items});

}
