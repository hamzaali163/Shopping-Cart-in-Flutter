// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:shoppingcart/cart_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:shoppingcart/database.dart';
import 'package:shoppingcart/productmodel.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartDatabase? cartDatabase = CartDatabase();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              label: Consumer<CartProvider>(
                builder: ((context, value, child) {
                  return Text(value.getcounter().toString());
                }),
              ),
              textStyle: const TextStyle(color: Colors.white),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getCartdata(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image(
                                        width: 100,
                                        height: 100,
                                        image: NetworkImage(snapshot
                                            .data![index].image
                                            .toString())),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot
                                                    .data![index].productName
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    cartDatabase!.deleteCart(
                                                        snapshot
                                                            .data![index].id!);
                                                    cart.removecounter();
                                                    cart.subtracttotalprice(
                                                        double.parse(snapshot
                                                            .data![index]
                                                            .productprice
                                                            .toString()));
                                                  },
                                                  child:
                                                      const Icon(Icons.delete))
                                            ],
                                          ),
                                          Text(
                                            snapshot.data![index].unittag +
                                                "  " +
                                                r"$" +
                                                snapshot
                                                    .data![index].productprice
                                                    .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.green),
                                              width: 110,
                                              height: 40,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          int quantity =
                                                              snapshot
                                                                  .data![index]
                                                                  .quantity;
                                                          int price = snapshot
                                                              .data![index]
                                                              .initialprice;
                                                          quantity++;
                                                          int newprice =
                                                              price * quantity;

                                                          cartDatabase!
                                                              .updateCart(Cart(
                                                            id: snapshot
                                                                .data![index]
                                                                .id,
                                                            productid: snapshot
                                                                .data![index]
                                                                .productid,
                                                            productName: snapshot
                                                                .data![index]
                                                                .productName,
                                                            initialprice: snapshot
                                                                .data![index]
                                                                .initialprice,
                                                            productprice:
                                                                newprice,
                                                            quantity: quantity,
                                                            unittag: snapshot
                                                                .data![index]
                                                                .unittag,
                                                            image: snapshot
                                                                .data![index]
                                                                .image,
                                                          ))
                                                              .then((value) {
                                                            newprice = 0;
                                                            quantity = 0;
                                                            cart.addtotalprice(
                                                                double.parse(snapshot
                                                                    .data![
                                                                        index]
                                                                    .initialprice
                                                                    .toString()));
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            Text(error
                                                                .toString());
                                                          });
                                                        },
                                                        child: const Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        )),
                                                    Text(
                                                      (snapshot
                                                          .data![index].quantity
                                                          .toString()),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          int quantity =
                                                              snapshot
                                                                  .data![index]
                                                                  .quantity;
                                                          int price = snapshot
                                                              .data![index]
                                                              .initialprice;
                                                          quantity--;
                                                          int newprice =
                                                              price * quantity;

                                                          if (quantity > 0) {
                                                            cartDatabase!
                                                                .updateCart(
                                                                    Cart(
                                                              id: snapshot
                                                                  .data![index]
                                                                  .id,
                                                              productid: snapshot
                                                                  .data![index]
                                                                  .productid,
                                                              productName: snapshot
                                                                  .data![index]
                                                                  .productName,
                                                              initialprice: snapshot
                                                                  .data![index]
                                                                  .initialprice,
                                                              productprice:
                                                                  newprice,
                                                              quantity:
                                                                  quantity,
                                                              unittag: snapshot
                                                                  .data![index]
                                                                  .unittag,
                                                              image: snapshot
                                                                  .data![index]
                                                                  .image,
                                                            ))
                                                                .then((value) {
                                                              newprice = 0;
                                                              quantity = 0;
                                                              cart.subtracttotalprice(
                                                                  double.parse(snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialprice
                                                                      .toString()));
                                                            }).onError((error,
                                                                    stackTrace) {
                                                              Text(error
                                                                  .toString());
                                                            });
                                                          }
                                                        },
                                                        child: const Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Text('Error');
                }
              }),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Consumer<CartProvider>(builder: (context, value, child) {
                return Visibility(
                  visible:
                      value.gettotalprice().toString() == '0.0' ? false : true,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ReusableRow(
                        title: 'Net Total',
                        value: r'$' + value.gettotalprice().toString(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ReusableRow(
                        title: 'Discount',
                        value2: r'$' + value.percentageprice().toString(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ReusableRow(
                        title: 'Final Price',
                        value2: r'$' + value.discountprice().toString(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  final String value2;
  // late double discount;

  const ReusableRow({
    super.key,
    this.title = '',
    this.value = '',
    this.value2 = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //  crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.white),
            ),
          ),
        const  SizedBox(
            width: 150,
          ),
          Text(
            value2,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.white),
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
