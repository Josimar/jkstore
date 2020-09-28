import 'package:flutter/material.dart';
import 'package:jkstore/screens/login_screen.dart';
import 'package:jkstore/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/user_model.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 171, 106, 68),
                Color.fromARGB(255, 208, 154, 110),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 140,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        "JK Store",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn()
                                    ? "Entre ou cadastre-se"
                                    : "Sair",
                                  style: TextStyle(
                                    color: Colors.white, //Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                onTap: (){
                                  if (!model.isLoggedIn()){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => LoginScreen())
                                    );
                                  }else{
                                    model.signOut();
                                  }
                                },
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Meus pedidos", pageController, 3),
              if (UserModel.of(context).isAdmin)
                DrawerTile(Icons.group_add, "Administração", pageController, 4)
            ],
          )
        ],
      ),
    );
  }
}
