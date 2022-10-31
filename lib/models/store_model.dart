class Store {
  final String StoreName;
  final String StoreLogo;
  final String kilometers;
  final num returnDays;
  final String StoreId;

  Store(
      {required this.StoreName,
      required this.StoreLogo,
      required this.kilometers,
      required this.returnDays,
      required this.StoreId});

  Map<String, dynamic> toJson() => {
        'StoreName': StoreName,
        'StoreLogo': StoreLogo,
        'kilometers': kilometers,
        'returnDays': returnDays,
        'StoreId': StoreId,
      };

  static Store fromJson(Map<String, dynamic> json) => Store(
        StoreName: json['StoreName'],
        StoreLogo: json['StoreLogo'],
        kilometers: json['kilometers'].toString(),
        returnDays: json['returnDays'],
        StoreId: json['StoreId'],
      );
}
