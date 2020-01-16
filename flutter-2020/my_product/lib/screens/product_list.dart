import 'dart:convert';

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

import "../widgets/main_drawer.dart";
import "../models/product.dart";

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PRODUCT"),
      ),
      drawer: MainDrawer(),
      body: Container(
        child: FutureBuilder(
          future: _getProducts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text('Loading...'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('https://demo.kidneylife.co.kr/upload/11111111/pat_profile/source/20171215102403_movie_image.jpg'),
                    ),
                    title: Text(snapshot.data[index].title),
                    subtitle: Text('${snapshot.data[index].price}'),
                    onTap: () {
                      //print(111);
                      Navigator.pushNamed<bool>(context, "/product/view/${snapshot.data[index].id}");
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed<bool>(context, "/product/new");
        },
        tooltip: "Add",
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Product>> _getProducts() async {
    var data = await http.get("https://express.datafirst.co.kr/restful/products");
    var rows = json.decode(data.body);
    List<Product> products = [];
    for (var row in rows) {
      Product product = Product(
        row["id"],
        row["title"],
        row["description"],
        row["imageUrl"],
        double.parse(row["price"]),
      );
      //print(product);
      products.add(product);
    }
    print('products length: ${products.length}');
    return products;
  }
}
