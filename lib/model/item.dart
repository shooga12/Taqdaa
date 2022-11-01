class Item {
  String? barcode;
  String? img;
  String? name;
  final num quantity;
  num? price;
  bool? returnable;
  String? size;

  Item(
      {this.barcode,
      this.name,
      this.img,
      required this.quantity,
      this.price,
      this.returnable,
      this.size});

  // receiving data from server
  factory Item.fromMap(map) {
    return Item(
      barcode: map['barcode'],
      name: map['name'],
      img: map['img'],
      quantity: map['quantity'],
      price: map['price'],
      returnable: map['returnable'],
      size: map['size'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'name': name,
      'img': img,
      'quantity': quantity,
      'price': price,
      'returnable': returnable,
      'size': size,
    };
  }
}
