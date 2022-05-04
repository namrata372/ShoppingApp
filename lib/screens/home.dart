import 'dart:convert';

import 'package:backdrop/backdrop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Utils/DatabaseHelper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/data/consts/colors.dart';
import 'package:shopping_app/data/models/product.dart';
import 'package:shopping_app/data/repository/DataProductRepository.dart';
import 'package:shopping_app/screens/product_details.dart';
import 'package:shopping_app/widget/backlayer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List _carouselImages = [
  'assets/images/carousel1.png',
  'assets/images/carousel2.jpeg',
  'assets/images/carousel3.jpg',
  'assets/images/carousel4.png',
];

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userImageUrl = '';

  /* @override
  Future<void> didChangeDependencies() async {
    List<CartAttr> cartList = [];

    CartProvider cartProvider = Provider.of<CartProvider>(context);

    cartList = cartProvider.getCartItems.values.toList();

    if (cartList.length == 0) {
      List<Map<String, dynamic>> attr = await dbHelper.queryAllRows();
      cartList = attr.cast<CartAttr>();
      cartList.forEach((element) {
        cartProvider.updateAccount(element);
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final productsData = Products();
    List<Product> products = [];
    User? user = _auth.currentUser;
    setState(() {
      user!.photoURL! != ''
          ? _userImageUrl = user.photoURL!
          : _userImageUrl =
              "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg";
    });

    return Scaffold(
      body: BackdropScaffold(
        frontLayerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        headerHeight: MediaQuery.of(context).size.height * 0.25,
        appBar: BackdropAppBar(
          title: Text("Home"),
          leading: BackdropToggleButton(icon: AnimatedIcons.home_menu),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              ColorsConsts.starterColor,
              ColorsConsts.endColor
            ])),
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 15,
              padding: const EdgeInsets.all(10),
              icon: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 13,
                  backgroundImage: NetworkImage(_userImageUrl),
                ),
              ),
              onPressed: () {},
            )
          ],
        ),
        backLayer: BackLayerMenu(_userImageUrl),
        frontLayer: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 190.0,
                  width: double.infinity,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 400.0,
                      autoPlay: true,
                      enableInfiniteScroll: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                    ),
                    items: _carouselImages
                        .map((item) => Container(
                              child: Center(
                                  child: Image.asset(item,
                                      fit: BoxFit.cover, width: 1000)),
                            ))
                        .toList(),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Popular Products',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 400,
                margin: EdgeInsets.symmetric(horizontal: 3),
                child: FutureBuilder(
                  future: productsData.fetchProducts(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      products = snapshot.data;
                      if (products.length > 0) {
                        return Container(
                          color: Colors.grey.shade100,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 0.68),
                            itemBuilder: (context, position) {
                              return gridItem(context, position, products);
                            },
                            itemCount: products.length,
                          ),
                          margin: EdgeInsets.only(
                              bottom: 8, left: 4, right: 4, top: 8),
                        );
                      } else {
                        return Container();
                      }
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  gridItem(BuildContext context, int position, List<Product> products) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: products[position]);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: Colors.grey.shade200)),
        margin: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(
                      image: NetworkImage(products[position].imageUrl),
                      fit: BoxFit.cover,
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      alignment: Alignment.topRight,
                      child: Container(
                        alignment: Alignment.center,
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.indigo),
                        child: Text(
                          "T",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 10),
/*                  style: CustomTextStyle.textFormFieldBold
                          .copyWith(color: Colors.white, fontSize: 10),*/
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              gridBottomView(position, products)
            ],
          ),
        ),
      ),
    );
  }

  gridBottomView(int position, List<Product> products) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 2),
          Container(
            child: Text(
              products[position].title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            alignment: Alignment.topLeft,
          ),
          SizedBox(height: 2),
          Text(
            "${products[position].brand}",
            style: TextStyle(color: Colors.indigo.shade700, fontSize: 14),
          ),
          Text(
            "\$ ${products[position].price}",
            //style: CustomTextStyle.textFormFieldBold.copyWith(color: Colors.indigo.shade700, fontSize: 14),
          ),
          SizedBox(height: 2),
        ],
      ),
    );
  }
}
