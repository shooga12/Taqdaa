import "item.dart";

class Invoice {
  String? id;
  String? store;
  String? date;
  num? total;
  num? vat_total;
  num? sub_total;
  num? rewardsDiscount;
  bool? HaveReturnReq;
  String? status;
  List<Item> items = [];

  Invoice(List items,
      {this.id,
      this.store,
      this.date,
      this.total,
      this.vat_total,
      this.sub_total,
      this.rewardsDiscount,
      this.HaveReturnReq,
      this.status}) {
    items.forEach((e) => this.items.add(Item.fromMap(e)));
  }

  // receiving data from server
  factory Invoice.fromMap(map) {
    return Invoice(map['items'],
        id: map['ID'],
        store: map['Store'],
        date: map['Date'],
        total: map['Total'],
        sub_total: map['sub-total'],
        vat_total: map['vat-total'],
        rewardsDiscount: map['rewardsDiscount'],
        HaveReturnReq: map['HaveReturnReq'],
        status: map['status']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store': store,
      'date': date,
      'total': total,
      'sub_total': sub_total,
      'vat_total': vat_total,
      'rewardsDiscount': rewardsDiscount,
      'HaveReturnReq': HaveReturnReq,
      'status': status,
      'items': items,
    };
  }
}
