import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/ui_elements/title_default.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  Widget _buildAddressPriceRow(double price) {
    return Row(children: <Widget>[
      Text('서울시 은평구'),
      SizedBox(width: 10.0),
      Text(
        '\$' + price.toString(),
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Back button press');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(product.image),
                height: 300.0,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/background.jpg'),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TitleDefault(product.title),
              ),
              _buildAddressPriceRow(product.price),
              Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
