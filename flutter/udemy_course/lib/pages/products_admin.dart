import 'package:flutter/material.dart';

import './product_form.dart';
import './product_list.dart';
import '../scoped-models/main.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Manager Products'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Product',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductFormPage(),
            ProductListPage(model),
          ],
        ),
      ),
    );
  }
}
