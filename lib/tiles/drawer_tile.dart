import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController pageController;
  final int pageActual;

  DrawerTile(this.icon, this.text, this.pageController, this.pageActual);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          pageController.jumpToPage(pageActual);
        },
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32,
                color: pageController.page.round() == pageActual ? Colors.white : Colors.orangeAccent,
              ),
              SizedBox(width: 32),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: pageController.page.round() == pageActual ? Colors.white : Colors.amber,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
