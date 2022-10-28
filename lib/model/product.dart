class Product {
  final String Category;
  final String Item_number;
  final int Price;
  final String Store;
  final int quantity;
  final String RFID;
  final String ProductImage;
  final bool returnable;

  Product(
      {required this.Category,
      required this.Item_number,
      required this.Price,
      required this.Store,
      required this.quantity,
      required this.RFID,
      required this.ProductImage,
      required this.returnable});

  Map<String, dynamic> toJson() => {
        'Category': Category,
        'Item_number': Item_number,
        'Price': Price,
        'Store': Store,
        'quantity': quantity,
        'RFID': RFID,
        'ProductImage': ProductImage,
        'returnable': returnable,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        Category: json['Category'],
        Item_number: json['Item_number'],
        Price: json['Price'],
        Store: json['Store'],
        quantity: json['quantity'],
        RFID: json['RFID'],
        ProductImage: json['ProductImage'],
        returnable: json['returnable'],
      );
}
