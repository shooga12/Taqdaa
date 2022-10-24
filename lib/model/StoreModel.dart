class Store {
  final String StoreName;
  final String StoreLogo;
  String kilometers;
  final String StoreId;
  final num lat;
  final num lng;

  Store(
      {required this.StoreName,
      required this.StoreLogo,
      required this.kilometers,
      required this.StoreId,
      required this.lat,
      required this.lng});

  Map<String, dynamic> toJson() => {
        'StoreName': StoreName,
        'StoreLogo': StoreLogo,
        'kilometers': kilometers,
        'StoreId': StoreId,
        'lat': lat,
        'lng': lng,
      };

  static Store fromJson(Map<String, dynamic> json) => Store(
        StoreName: json['StoreName'],
        StoreLogo: json['StoreLogo'],
        kilometers: json['kilometers'].toString(),
        StoreId: json['StoreId'],
        lat: json['lat'],
        lng: json['lng'],
      );
}
