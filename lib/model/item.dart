class Item {
  String? barcode;
  String? img;
  String? name;
  num? quantity;
  num? price;
  bool? returnable;
  bool? returnRequest;

  Item({
    this.barcode,
    this.name,
    this.img,
    this.quantity,
    this.price,
    this.returnable,
    this.returnRequest,
  });

  // receiving data from server
  factory Item.fromMap(map) {
    return Item(
      barcode: map['barcode'],
      name: map['name'],
      img: map['img'],
      quantity: map['quantity'],
      price: map['price'],
      returnable: map['returnable'],
      returnRequest: map['returnRequest'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'name': name,
      'quantity': quantity,
      'price': price,
      'returnable': returnable,
      'returnRequest': returnRequest,
    };
  }
}
