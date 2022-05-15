class MembershipModel {
  String name = '';

  // in months
  int duration = 0;
  double price = 0.00;
  String description = '', shortDescription = '';
  Map<String, bool> benefits = {};

  MembershipModel(
      {required this.name,
      required this.duration,
      required this.price,
      required this.description,
      required this.benefits, required this.shortDescription});
}
