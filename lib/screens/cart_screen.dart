import 'package:flutter/material.dart';
import 'package:jkstore/models/cart_model.dart';
import 'package:jkstore/models/user_model.dart';
import 'package:jkstore/screens/order_screen.dart';
import 'package:jkstore/tiles/cart_tile.dart';
import 'package:jkstore/widgets/cart_price.dart';
import 'package:jkstore/widgets/discount_card.dart';
import 'package:jkstore/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu carrinho"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int tam = model.products.length;
                return Text(
                  "${tam ?? 0} ${tam == 1 ? "Item" : "Itens"}",
                  style: TextStyle(fontSize: 17),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){
          if (model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if (! UserModel.of(context).isLoggedIn()){
            return Container (
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Faça o login para adicionar o produto",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18)
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>LoginScreen())
                      );
                    },
                  )
                ],
              ),
            );
          }else if(model.products == null || model.products.length == 0){
            return Center(
              child: Text(
                "Nenhum produto no carrinho",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }else{
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map(
                      (product){
                        return CartTile(product);
                      }
                  ).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async {
                  String orderId = await model.finishOrder();
                  if (orderId != null){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=>OrderScreen(orderId))
                    );
                  }
                })
              ],
            );
          }
        },
      ),
    );
  }
}
