import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';

class Checkoutitem {
  final String cid;
  final int camount;
  final DateTime ctime;
  final List<CartItem> cproducts;

  Checkoutitem({
    this.cid,
    this.camount,
    this.ctime,
    this.cproducts,
  });
}

class Checkout with ChangeNotifier {
  List<Checkoutitem> _checkout = [];
  List<Checkoutitem> get checkout {
    return [..._checkout];
  }

  final String authToken;
  final String userId;

  Checkout(this.authToken, this.userId, this._checkout);

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-update.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<Checkoutitem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        Checkoutitem(
          cid: orderId,
          camount: orderData['amount'],
          ctime: DateTime.parse(orderData['dateTime']),
          cproducts: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      name: item['name'],
                    ),
              )
              .toList(),
        ),
      );
    });
    _checkout = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, int total) async {
    final url = 'https://flutter-update.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.name,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _checkout.insert(
      0,
      Checkoutitem(
        cid: json.decode(response.body)['name'],
        camount: total,
        ctime: timestamp,
        cproducts: cartProducts,
      ),
    );
    notifyListeners();
  }
}
