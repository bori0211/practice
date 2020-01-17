import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

import "../models/product.dart";

class ProductViewScreen extends StatefulWidget {
  final int selectedId;

  ProductViewScreen(this.selectedId);

  @override
  State<StatefulWidget> createState() {
    return _ProductViewScreenState();
  }
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  Future<Product> _getProduct() async {
    var data = await http.get("https://express.datafirst.co.kr/restful/products/${widget.selectedId}");
    var row = json.decode(data.body);
    Product product = Product(
      row["id"],
      row["title"],
      row["description"],
      row["imageUrl"],
      double.parse(row["price"]),
    );
    //print(product.title);
    return product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VIEW"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed<bool>(context, "/product/modify/${widget.selectedId}");
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: _getProduct(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return Center(
                child: Text(snapshot.data.title),
              );
            }
          },
        ),
      ),
    );
  }

  _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("정말 삭제하시겠습니까?"),
          content: Text("삭제하면 되돌릴 수 없습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text("취소"),
              textColor: Colors.grey,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("삭제"),
              textColor: Colors.red,
              onPressed: () async {
                // 데이터 삭제 후 리스트로 돌아감
                if (await _deleteProduct()) {
                  Navigator.pushReplacementNamed(context, "/product");
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _deleteProduct() async {
    try {
      final http.Response response = await http.delete(
        "https://express.datafirst.co.kr/restful/products/${widget.selectedId}",
      );
      var responseBody = json.decode(response.body);
      return responseBody["result"];
    } catch (error) {
      return false;
    }
  }
}
