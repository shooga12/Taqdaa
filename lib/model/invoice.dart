class Invoice {
  String? id;
  String? store;
  String? date;


  Invoice({
    this.id,
    this.store,
    this.date,

  });

  // receiving data from server
  factory Invoice.fromMap(map) {
    return Invoice(
      id: map['ID'],
      store: map['Store'],
      date: map['Date'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store': store,
      'date': date,
    };
  }
}
