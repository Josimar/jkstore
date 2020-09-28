import 'package:flutter/material.dart';
import 'package:jkstore/models/user_model.dart';
import 'package:jkstore/tabs/admin_tab.dart';
import 'package:jkstore/tabs/home_tab.dart';
import 'package:jkstore/tabs/orders_tab.dart';
import 'package:jkstore/tabs/places_tab.dart';
import 'package:jkstore/tabs/products_tab.dart';
import 'package:jkstore/widgets/cart_button.dart';
import 'package:jkstore/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Scaffold(
            body: HomeTab(),
            drawer: CustomDrawer(_pageController),
            floatingActionButton: CartButton(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Produtos"),
              centerTitle: true,
            ),
            body: ProductsTab(),
            drawer: CustomDrawer(_pageController),
            floatingActionButton: CartButton(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Lojas"),
              centerTitle: true,
            ),
            body: PlacesTab(),
            drawer: CustomDrawer(_pageController),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Meus pedidos"),
              centerTitle: true,
            ),
            body: OrdersTab(),
            drawer: CustomDrawer(_pageController),
          ),
          if (UserModel.of(context).isAdmin)
          Scaffold(
            appBar: AppBar(
              title: Text("Administração"),
              centerTitle: true,
            ),
            body: AdminTab(),
            drawer: CustomDrawer(_pageController),
          ),
        ],
    );
  }
}
