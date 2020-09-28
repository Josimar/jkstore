import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jkstore/blocs/orders_bloc.dart';
import 'package:jkstore/blocs/user_bloc.dart';
import 'package:jkstore/tabs/products_admin_tab.dart';
import 'package:jkstore/tabs/products_tab.dart';
import 'package:jkstore/tabs/users_tab.dart';
import 'package:jkstore/widgets/edit_category_dialog.dart';

import 'orders_admin_tab.dart';

class AdminTab extends StatefulWidget {

  @override
  _AdminTabState createState() => _AdminTabState();
}

class _AdminTabState extends State<AdminTab> {
  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _userBloc.dispose();
    _ordersBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [Bloc((i) => UserBloc()), Bloc((i) => OrdersBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.grey,
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Color.fromARGB(255, 4, 125, 141),
                  primaryColor: Colors.white,
                  textTheme: Theme.of(context).textTheme.copyWith(
                    caption: TextStyle(color: Colors.white54)
                  )
              ),
              child: BottomNavigationBar(
                currentIndex: _page,
              onTap: (p){
                _pageController.animateToPage(p, duration: Duration(milliseconds: 500), curve: Curves.ease);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text("Clientes")
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  title: Text("Pedidos")
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    title: Text("Produtos")
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: PageView(
              controller: _pageController,
              onPageChanged: (p){
                setState(() {
                  _page = p;
                });
              },
              children: <Widget>[
                UsersTab(),
                OrdersAdminTab(),
                ProductsAdminTab()
              ],
            ),
          ),
          floatingActionButton: _buildFloating(),
        ),
      ),
    );
  }

  Widget _buildFloating(){
    switch(_page){
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(Icons.arrow_downward, color: Colors.pinkAccent,),
                backgroundColor: Colors.white,
                label: 'Concluídos abaixo',
                labelStyle: TextStyle(fontSize: 14),
                onTap: (){
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.pinkAccent,),
                backgroundColor: Colors.white,
                label: 'Concluídos acima',
                labelStyle: TextStyle(fontSize: 14),
                onTap: (){
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                }
            ),
          ],
        );
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: (){
            showDialog(
                context: context,
                builder: (context)=> EditCategoryDialog()
            );
          },
        );
      default:
        return null;
        break;
    }
  }

}


