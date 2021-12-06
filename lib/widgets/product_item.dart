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
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Card(
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
                      fit: BoxFit.cover,
                      height: 157,
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
                  child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16, top: 18),
                    alignment: Alignment.topLeft,
                    child: Text(
                      product.title,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(left: 16, bottom: 18),
                        child: Text(
                          '\$${product.price}',
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(bottom: 18),
                        child: IconButton(
                          color: Theme.of(context).accentColor,
                          icon: Icon(Icons.shopping_cart),
                          onPressed: () {
                            cart.addItem(
                                product.id, product.price, product.title);
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
                        ),
                      )
                    ],
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
