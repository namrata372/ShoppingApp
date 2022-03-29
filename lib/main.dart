import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/bottom_bar.dart';
import 'package:shopping_app/screens/cart/cart.dart';
import 'package:shopping_app/screens/landing_page.dart';
import 'package:shopping_app/screens/product_details.dart';
import 'package:shopping_app/screens/upload_product_form.dart';
import 'package:shopping_app/screens/user_state.dart';
import 'package:shopping_app/viewmodel/cart_provider.dart';
import 'package:shopping_app/viewmodel/products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Error occured'),
                ),
              ),
            );
          }

          /* return MaterialApp(
            title: 'Flutter Shop',
            home: UserState(),
            //initialRoute: '/',
            routes: {
              // '/': (ctx) => LandingPage(),
              //CartScreen.routeName: (ctx) => CartScreen(),
              // Feeds.routeName: (ctx) => Feeds(),
              //WishlistScreen.routeName: (ctx) => WishlistScreen(),
              ProductDetails.routeName: (ctx) => ProductDetails(),
              //CategoriesFeedsScreen.routeName: (ctx) => CategoriesFeedsScreen(),
              BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
              UploadProductForm.routeName: (ctx) => UploadProductForm(),
              // OrderScreen.routeName: (ctx) => OrderScreen(),
            },
          );*/
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => Products(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
            ],
            child: Consumer<CartProvider>(
              builder: (context, themeChangeProvider, ch) {
                return MaterialApp(
                  title: 'Flutter Shop',

                  home: UserState(),
                  //initialRoute: '/',
                  routes: {
                    //   '/': (ctx) => LandingPage(),

                    // '/': (ctx) => LandingPage(),
                    CartScreen.routeName: (ctx) => CartScreen(),
                    // Feeds.routeName: (ctx) => Feeds(),
                    //WishlistScreen.routeName: (ctx) => WishlistScreen(),
                    ProductDetails.routeName: (ctx) => ProductDetails(),
                    //CategoriesFeedsScreen.routeName: (ctx) => CategoriesFeedsScreen(),
                    BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
                    UploadProductForm.routeName: (ctx) => UploadProductForm(),
                    // OrderScreen.routeName: (ctx) => OrderScreen(),
                  },
                );
              },
            ),
          );
        });
  }
}
