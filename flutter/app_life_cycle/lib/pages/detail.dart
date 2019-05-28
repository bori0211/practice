import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './form.dart';
import '../models/product.dart';

class DetailPage extends StatefulWidget {
  final int selectedId;

  DetailPage(this.selectedId);

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    print('_DetailPageState: ${widget.selectedId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Name'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed<bool>(context, '/modify/${widget.selectedId}');
              /*Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return FormPage('1');
                }),
              );*/
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
                child: Text('Loading...'),
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
            title: Text('정말 삭제하시겠습니까?'),
            content: Text('삭제하면 되돌릴 수 없습니다.'),
            actions: <Widget>[
              FlatButton(
                child: Text('취소'),
                textColor: Colors.grey,
                onPressed: () {
                  print('취소함');
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('삭제'),
                textColor: Colors.black,
                onPressed: () async {
                  print('승인');
                  Navigator.pop(context); // alert 닫힘
                  // 데이터 삭제 후 리스트로 돌아감
                  if (await _deleteProduct()) Navigator.pop(context, true); // 리스트로
                },
              ),
            ],
          );
        });
  }

  Future<Product> _getProduct() async {
    var data = await http.get('https://express.datafirst.co.kr/restful/products/${widget.selectedId}');
    var row = json.decode(data.body);
    Product product = Product(row['id'], row['title'], row['description'], row['imageUrl'], double.parse(row['price']));
    print(product.title);
    return product;
  }

  Future<bool> _deleteProduct() async {
    try {
      //print(json.encode(_formData));
      final http.Response response = await http.delete(
        'https://express.datafirst.co.kr/restful/products/${widget.selectedId}',
      );
      if (response.statusCode != 200 && response.statusCode != 201) return false;
      // 여기에서 State에 저장
      return true;
    } catch (error) {
      return false;
    }
  }
}
