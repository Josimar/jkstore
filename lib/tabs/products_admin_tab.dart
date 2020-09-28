import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jkstore/tiles/category_admin_tile.dart';

class ProductsAdminTab extends StatefulWidget {
  @override
  _ProductsAdminTabState createState() => _ProductsAdminTabState();
}

class _ProductsAdminTabState extends State<ProductsAdminTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // return FutureBuilder<QuerySnapshot>( // espera a base de dados
    return StreamBuilder<QuerySnapshot>(
      // future: Firestore.instance.collection("products").getDocuments(),  // espera a base de dados
      stream: Firestore.instance.collection("products").snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return CategoryAdminTile(snapshot.data.documents[index]);
          }
        );

      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
