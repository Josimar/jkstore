import 'package:flutter/material.dart';
import 'package:jkstore/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/user_model.dart';
import 'screens/home.dart';

// Gerar a chave
// keytool -genkey -v -keystore jkstoreonline.keystore -alias jk_online_store -keyalg RSA -keysize 2048 -validity 10000
// Pegar a chave
// keytool -list -v -alias jk_online_store -keystore jkstoreonline.keystore
// Assinar aplicativo - no diretório
// keytool -genkey -v -keystore c:/JKStoreOnLine.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key

// https://icons8.com/icons/set/shoes
// http://png.icons8.com/color/1600/shoes.png

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
                title: 'Loja virtual',
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    primaryColor: Color.fromARGB(255, 4, 125, 141)
                ),
                debugShowCheckedModeBanner: false,
                home: HomeScreen()
            ),
          );
        },
      ),
    );
  }
}
