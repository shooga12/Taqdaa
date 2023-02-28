import "item.dart";

class returnInvoice {
  String? id;
  String? store;
  String? date;
  num? total;
  num? vat_total;
  num? sub_total;
  List<Item> items = [];
  bool? HaveReturnReq;
  String? status;
  //DateTime? Fulldate;
  // bool? isExpired;
  // int? returnDays;

  returnInvoice(
    List items, {
    this.id,
    this.store,
    this.date,
    this.total,
    this.vat_total,
    this.sub_total,
    this.status,
    //this.Fulldate,
    // this.isExpired,
    // this.returnDays,
  }) {
    items.forEach((e) => this.items.add(Item.fromMap(e)));
  }

  // receiving data from server
  factory returnInvoice.fromMap(map) {
    return returnInvoice(
      map['items'],
      id: map['ID'],
      store: map['Store'],
      date: map['Date'],
      total: map['Total'],
      sub_total: map['sub-total'],
      vat_total: map['vat-total'],
      status: map['status'],
      //Fulldate: map['Fulldate'],
      // isExpired: map['isExpired'],
      // returnDays: map['returnDays'],
    );
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
      'items': items,
      'status': status,
      //'Fulldate': Fulldate,
      // 'isExpired': isExpired,
      // 'returnDays': returnDays,
    };
  }

  static returnInvoice fromJson(Map<String, dynamic> json) => returnInvoice(
        json['items'],
        id: json['id'],
        store: json['store'],
        date: json['date'],
        total: json['total'],
        sub_total: json['sub-total'],
        vat_total: json['vat-total'],
        status: json['status'],
      );
}
