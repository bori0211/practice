import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './product_form.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListPage();
  }
}

class _ProductListPage extends State<ProductListPage> {
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.allProducts[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductFormPage();
            },
          ),
        ).then((_) {
          model.selectProduct(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.allProducts[index].title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  //print('Swiped end to start');
                  model.selectProduct(model.allProducts[index].id);
                  model.deleteProduct();
                } else if (direction == DismissDirection.startToEnd) {
                  print('Swiped start to end');
                } else {
                  print('Other swiped');
                }
              },
              background: Container(color: Colors.red),
              child: Column(children: <Widget>[
                ListTile(
                  /*leading: CircleAvatar(
              backgroundImage: Image.asset(products[index]['image']),
              ),*/
                  title: Text(model.allProducts[index].title),
                  subtitle: Text('\$${model.allProducts[index].price}'),
                  trailing: _buildEditButton(context, index, model),
                ),
                Divider(),
              ]),
            );
          },
          itemCount: model.allProducts.length,
        );
      },
    );
  }
}
