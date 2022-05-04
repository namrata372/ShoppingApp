import 'package:flutter/cupertino.dart';
import 'package:shopping_app/Utils/DatabaseHelper.dart';
import 'package:shopping_app/data/models/cart_attr.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};
  final dbHelper = DatabaseHelper.instance;

  Map<String, CartAttr> get getCartItems {
    getFromdb();
    return {..._cartItems};
  }

  getFromdb() async {
    List<CartAttr> cartList = [];

    if (_cartItems.length == 0) {
      List<Map<String, dynamic>> attr = await dbHelper.queryAllRows();

      for (var n in attr) {
        cartList.add(CartAttr.fromJson(n));
      }
      //   cartList = attr.cast<CartAttr>();
      print(cartList.length);
      cartList.forEach((element) {
        print(element);
        updateAccount(element);
      });
    }
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += double.parse(value.price) * value.quantity;
    });
    return total;
  }

  Future<void> addProductToCart(
      String productId, String price, String title, String imageUrl) async {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (exitingCartItem) => CartAttr(
              id: exitingCartItem.id,
              productId: exitingCartItem.productId,
              title: exitingCartItem.title,
              price: exitingCartItem.price,
              quantity: exitingCartItem.quantity + 1,
              imageUrl: exitingCartItem.imageUrl));

      CartAttr cartAttr =
          _cartItems.values.where((element) => productId == productId).first;
      final rowsAffected = await dbHelper.update(
          cartAttr.productId, (cartAttr.quantity).toString());
      print("----------${rowsAffected}");
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttr(
              id: DateTime.now().toString(),
              productId: productId,
              title: title,
              price: price,
              quantity: 1,
              imageUrl: imageUrl));
      Map<String, dynamic> row = {
        DatabaseHelper.columnId: DateTime.now().toString(),
        DatabaseHelper.columnProductId: productId,
        DatabaseHelper.columnTitle: title,
        DatabaseHelper.columnPrice: price,
        DatabaseHelper.columnQuantity: 1,
        DatabaseHelper.columnImageUrl: imageUrl
      };
      final rowsAffected = await dbHelper.insert(row);
      print("----------${rowsAffected}");
    }
    notifyListeners();
  }

  Future<void> reduceItemByOne(
    String productId,
  ) async {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (exitingCartItem) => CartAttr(
              id: exitingCartItem.id,
              productId: exitingCartItem.productId,
              title: exitingCartItem.title,
              price: exitingCartItem.price,
              quantity: exitingCartItem.quantity - 1 > 0
                  ? exitingCartItem.quantity - 1
                  : 0,
              imageUrl: exitingCartItem.imageUrl));
      CartAttr cartAttr =
          _cartItems.values.where((element) => productId == productId).first;
      final rowsAffected = await dbHelper.update(
          cartAttr.productId, (cartAttr.quantity).toString());
      print("----------${rowsAffected}");
      notifyListeners();
    }
  }

  Future<void> removeItem(String productId) async {
    _cartItems.remove(productId);
    final rowsDeleted = await dbHelper.delete(productId);
    print('deleted $rowsDeleted row(s): row $productId');
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    dbHelper.DropDb();
    print('deleted Database');
    notifyListeners();
  }

  void updateAccount(CartAttr input) {
    _cartItems.putIfAbsent(
        input.productId,
        () => CartAttr(
            id: input.id,
            productId: input.productId,
            title: input.title,
            price: input.price,
            quantity: input.quantity,
            imageUrl: input.imageUrl));
    notifyListeners();
  }
}
