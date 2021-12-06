import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return Card(
<<<<<<< HEAD
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
=======
>>>>>>> 92086f0942c947b79f1f4ceae6a76ef9466b3cf6
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: product.id,
                  );
                },
                child: Image.network(
                  product.imageUrl,
<<<<<<< HEAD
                  fit: BoxFit.fill,
=======
                  fit: BoxFit.cover,
>>>>>>> 92086f0942c947b79f1f4ceae6a76ef9466b3cf6
                  height: 160,
                  width: double.infinity,
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: Consumer<Product>(
                  builder: (ctx, product, child) => IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    onPressed: () {
                      product.toggleFavoriteStatus();
                    },
                    color: Theme.of(context).accentColor,
                  ),
                  child: Text(
                      'Never changes!'), // doesn't rebuild when Consumer updates
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 16),
                  alignment: Alignment.topLeft,
                  child: Text(
                    product.title,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        '\$${product.price}',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cart.addItem(product.id, product.price, product.title);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added item to cart!',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 2),
                            action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  cart.removeSingleItem(
                                    product.id,
                                  );
                                }),
                          ),
                        );
                      },
                      child: Container(
                        child: Icon(
                          Icons.add_circle_rounded,
<<<<<<< HEAD
                          color: Theme.of(context).accentColor,
=======
>>>>>>> 92086f0942c947b79f1f4ceae6a76ef9466b3cf6
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
