import 'package:flutter/material.dart';
import 'package:shoppingcart/cart_provider.dart';
import 'package:shoppingcart/cartscreen.dart';
import 'package:shoppingcart/database.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:shoppingcart/productmodel.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  CartDatabase? cartDatabase = CartDatabase();

  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];
  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  List<int> productprice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              child: Center(
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
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: productName.length,
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
                                  image: NetworkImage(productImage[index])),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName[index].toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      productUnit[index] +
                                          "  " +
                                          r"$" +
                                          productprice[index].toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          cartDatabase!
                                              .insert(
                                            Cart(
                                                id: index,
                                                productid: index.toString(),
                                                productName: productName[index],
                                                initialprice:
                                                    productprice[index],
                                                productprice:
                                                    productprice[index],
                                                quantity: 1,
                                                unittag: productUnit[index]
                                                    .toString(),
                                                image: productImage[index]
                                                    .toString()),
                                          )
                                              .then((value) {
                                            cart.addcounter();
                                            cart.addtotalprice(double.parse(
                                                productprice[index]
                                                    .toString()));
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.green),
                                          width: 110,
                                          height: 40,
                                          child: const Center(
                                            child: Text(
                                              'Add to Cart',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
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
            ),
          ],
        ));
  }
}
