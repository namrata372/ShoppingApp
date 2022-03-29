//import 'package:shopping_app/screens/search.dart';
import 'package:shopping_app/screens/home.dart';
import 'package:shopping_app/screens/upload_product_form.dart';
import 'package:shopping_app/screens/user_info.dart';
import 'package:flutter/material.dart';

import 'cart/cart.dart';

/*
import 'cart/cart.dart';
import 'feeds.dart';
import 'home.dart';
*/

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedPageIndex = 0;
  List<Widget> pages = [];
  @override
  void initState() {
    pages = [
      Home(),
      CartScreen(),

      UserInfo(),
      UploadProductForm(),
      //Feeds(),
      // Search(),
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedPageIndex], //_pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        // color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: kBottomNavigationBarHeight * 0.98,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).textSelectionColor,
              selectedItemColor: Colors.purple,
              currentIndex: _selectedPageIndex,
              // selectedLabelStyle: TextStyle(fontSize: 16),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  // title: Text('Home'),
                  label: 'Home',
                ),
                /*  BottomNavigationBarItem(
                    icon: Icon(Icons.featured_play_list), label: 'Feeds'),*/
                /*  BottomNavigationBarItem(
                    activeIcon: null, icon: Icon(null), label: 'Search'),*/
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shopping_cart,
                    ),
                    label: 'Cart'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_box), label: 'User'),
              ],
            ),
          ),
        ),
      ),
      /*  floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          hoverElevation: 10,
          splashColor: Colors.grey,
          tooltip: 'Search',
          elevation: 4,
          child: Icon(Icons.search),
          onPressed: () => setState(() {
            _selectedPageIndex = 2;
          }),
        ),
      ),*/
    );
  }
}
