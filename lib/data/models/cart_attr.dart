import 'package:flutter/material.dart';

class CartAttr with ChangeNotifier {
  late final String id;
  late final String productId;
  late final String title;
  late final int quantity;
  late final String price;
  late final String imageUrl;
  CartAttr(
      {required this.id,
      required this.productId,
      required this.title,
      required this.quantity,
      required this.price,
      required this.imageUrl});

  CartAttr.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    title = json['title'];
    quantity = json['quantity'];
    price = json['price'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['title'] = this.title;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
