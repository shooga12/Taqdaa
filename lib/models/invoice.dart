import "item.dart";

class Invoice {
  String? id;
  String? store;
  String? date;
  DateTime? Fulldate;
  num? total;
  num? returnDays;
  num? vat_total;
  num? sub_total;
  num? rewardsDiscount;
  bool? HaveReturnReq;
  bool? isExpired;
  List<Item> items = [];

  Invoice(List items,
      {this.id,
      this.store,
      this.date,
      this.Fulldate,
      this.total,
      this.returnDays,
      this.vat_total,
      this.sub_total,
      this.rewardsDiscount,
      this.HaveReturnReq,
      this.isExpired}) {
    items.forEach((e) => this.items.add(Item.fromMap(e)));
  }

  // receiving data from server
  factory Invoice.fromMap(map) {
    return Invoice(map['items'],
        id: map['ID'],
        store: map['Store'],
        date: map['Date'],
        //Fulldate: map['Fulldate'],
        total: map['Total'],
        returnDays: map['returnDays'],
        sub_total: map['sub-total'],
        vat_total: map['vat-total'],
        rewardsDiscount: map['rewardsDiscount'],
        HaveReturnReq: map['HaveReturnReq'],
        isExpired: map['isExpired']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store': store,
      'date': date,
      'Fulldate': Fulldate,
      'total': total,
      'returnDays': returnDays,
      'sub_total': sub_total,
      'vat_total': vat_total,
      'rewardsDiscount': rewardsDiscount,
      'HaveReturnReq': HaveReturnReq,
      'isExpired': isExpired,
      'items': items,
    };
  }

  static Invoice fromJson(Map<String, dynamic> json) => Invoice(json['items'],
      id: json['ID'],
      store: json['Store'],
      date: json['Date'],
      Fulldate: json['Fulldate'],
      total: json['Total'],
      returnDays: json['returnDays'],
      sub_total: json['sub-total'],
      vat_total: json['vat-total'],
      rewardsDiscount: json['rewardsDiscount'],
      HaveReturnReq: json['HaveReturnReq'],
      isExpired: json['isExpired']);
}
