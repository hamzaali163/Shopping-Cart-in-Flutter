// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'productmodel.dart';

class CartDatabase {
  static Database? _db;

  // ignore: body_might_complete_normally_nullable
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initdatabase();
  }

  initdatabase() async {
    //create database inside phone.
    io.Directory documentdirectory = await getApplicationDocumentsDirectory();
    //assign path.
    String path = join(documentdirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _oncreate);
    return db;
  }
//old one:
  // _oncreate(Database db, int version) async {
  //   await db.execute(
  //       'CREATE TABLE cart (id INTEGER PRIMARY KEY ,productid VARCHAR UNIQUE,productName TEXT,initialprice INTEGER, productprice INTEGER , quantity INTEGER, productUnit TEXT, unitTag TEXT , productImage TEXT )');
  // }

  _oncreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart (id INTEGER PRIMARY KEY , productid VARCHAR UNIQUE, productname TEXT, initialprice INTEGER, productprice INTEGER , quantity INTEGER, unittag TEXT , image TEXT )');
  }

  Future<Cart> insert(Cart cart) async {
    var dbclient = await db;
    await dbclient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCart() async {
    var dbclient = await db;
    final List<Map<String, Object?>> queryresult =
        await dbclient!.query('cart');
    return queryresult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> deleteCart(int id) async {
    var dbclient = await db;
    return await dbclient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateCart(Cart cart) async {
    var dbclient = await db;
    return await dbclient!
        .update('cart', cart.toMap(), where: 'id = ?', whereArgs: [cart.id]);
  }
}
