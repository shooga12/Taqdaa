class Offer {
  final String StoreName;
  final String OfferImg;
  final String StoreId;
  final String percentage;
  final String offerText;

  Offer(
      {required this.StoreName,
      required this.OfferImg,
      required this.StoreId,
      required this.percentage,
      required this.offerText});

  Map<String, dynamic> toJson() => {
        'StoreName': StoreName,
        'OfferImg': OfferImg,
        'StoreId': StoreId,
        'percentage': percentage,
        'offerText': offerText,
      };

  static Offer fromJson(Map<String, dynamic> json) => Offer(
        StoreName: json['StoreName'],
        OfferImg: json['OfferImg'],
        StoreId: json['StoreId'],
        percentage: json['percentage'],
        offerText: json['offerText'],
      );
}
