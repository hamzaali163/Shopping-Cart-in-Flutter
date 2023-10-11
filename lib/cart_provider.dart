import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcart/database.dart';
import 'package:shoppingcart/productmodel.dart';

class CartProvider with ChangeNotifier {
  CartDatabase cartDatabase = CartDatabase();
  int _counter = 0;
  double _totalprice = 0.0;

  int get counter => _counter;
  double get totalprice => _totalprice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getCartdata() async {
    _cart = cartDatabase.getCart();
    return _cart;
  }

  void setpref() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setInt('cart_item', _counter);
    sp.setDouble('price', _totalprice);
    notifyListeners();
  }

  void getpref() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    _counter = sp.getInt('cart_item') ?? 0;
    _totalprice = sp.getDouble('price') ?? 0.0;
    notifyListeners();
  }

  addcounter() {
    _counter++;
    setpref();
    notifyListeners();
  }

  void removecounter() {
    _counter--;
    setpref();
    notifyListeners();
  }

  int getcounter() {
    getpref();
    return _counter;
  }

  int getremovecounter() {
    getpref();
    return _counter;
  }

//total price:
  addtotalprice(double productPrice) {
    _totalprice = totalprice + productPrice;
    setpref();
    notifyListeners();
  }

  void subtracttotalprice(double productPrice) {
    _totalprice = totalprice - productPrice;
    setpref();
    notifyListeners();
  }

  double gettotalprice() {
    getpref();

    return _totalprice;
  }

  double percentageprice() {
    getpref();
    double discount = 0;
    discount = totalprice * 0.15;
    return discount;
  }

  // double discountprice() {
  //   getpref();
  //   double discount;
  //   discount = _totalprice * 0.15;
  //   _totalprice = totalprice - discount;
  //   return totalprice;
  // }

  double discountprice() {
    getpref();
    percentageprice();
    double discount;
    //  double discount;
    discount = _totalprice * 0.15;
    _totalprice = totalprice - discount;
    return totalprice;
  }
}
