import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/helpers/custom_route.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/splash_screen.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import 'providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (context, auth, previousProduct) => Products(
              auth.token,
              previousProduct == null ? [] : previousProduct.items,
              auth.userId),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, previous) => Orders(
              auth.token, previous == null ? [] : previous.orders, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            })
          ),
          home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
          
        ),
        
      ),
      
    );
  }
}
