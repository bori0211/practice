import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/side_drawer.dart';
import '../models/product.dart';

class ListPage extends StatefulWidget {
  final String selectedStatus;

  ListPage(this.selectedStatus);

  @override
  State<StatefulWidget> createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> {
  List<Product> _products = [];
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(title: Text('Home')),
      body: RefreshIndicator(
        key: refreshKey,
        child: _buildListView(context),
        onRefresh: _getProducts,
      ),
      /*body: Container(
        child: FutureBuilder(
          future: _getProducts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text('Loading...'),
              );
            } else {
              return _buildListView(context);
            }
          },
        ),
      ),*/
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.pushNamed<bool>(context, '/new');
        },
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key('$index'),
          onDismissed: (DismissDirection direction) async {
            if (direction == DismissDirection.endToStart) {
              print('Swiped end to start');
              String targetStatus = '';
              if (widget.selectedStatus == '대기중') targetStatus = '판매중';
              if (widget.selectedStatus == '판매중') targetStatus = '판매종료';
              if (widget.selectedStatus == '판매종료') targetStatus = '대기중';

              if (await _patchProduct(_products[index].id, targetStatus)) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('${_products[index].id} $targetStatus 상태로 변경됨'),
                ));
              }
            } else if (direction == DismissDirection.startToEnd) {
              print('Swiped start to end');

              String targetStatus = '';
              if (widget.selectedStatus == '대기중') targetStatus = '판매종료';
              if (widget.selectedStatus == '판매중') targetStatus = '대기중';
              if (widget.selectedStatus == '판매종료') targetStatus = '판매중';

              if (await _patchProduct(_products[index].id, targetStatus)) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('${_products[index].id} $targetStatus 상태로 변경됨'),
                ));
              }
            } else {
              print('Other swiped');
            }
          },
          background: Container(color: Colors.green),
          secondaryBackground: Container(color: Colors.red),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://demo.kidneylife.co.kr/upload/11111111/pat_profile/source/20171215102403_movie_image.jpg'),
            ),
            title: Text(_products[index].title),
            subtitle: Text('${_products[index].price}'),
            onTap: () {
              //print(111);
              Navigator.pushNamed<bool>(context, '/detail/${_products[index].id}');
            },
            //onTap: () => Navigator.pushNamed<bool>(context, '/product/' + '335'),
            //onTap: () => Navigator.pushNamed(context, '/detail/' + snapshot.data[index].index),
          ),
        );
      },
    );
  }

  Future<Null> _getProducts() async {
    var data = await http.get('https://express.datafirst.co.kr/mysql/products?status=${widget.selectedStatus}');
    var rows = json.decode(data.body);
    //List<Product> products = [];
    for (var row in rows) {
      Product product = Product(row['id'], row['title'], row['description'], row['imageUrl'], double.parse(row['price']));
      //this.id, this.title, this.description, this.imageUrl, this.price
      //print(product);
      setState(() {
        //list = List.generate(random.nextInt(10), (i) => "Item $i");
        _products.add(product);
      });
      //products.add(product);
    }
    print('_HomePageState users length: ${_products.length}');
    //return products;
  }

  Future<bool> _patchProduct(int selectedId, String status) async {
    try {
      //print(json.encode(_formData));
      final http.Response response = await http.patch(
        'https://express.datafirst.co.kr/mysql/products/${selectedId}',
        headers: {"Content-Type": "application/json"},
        body: json.encode({'which': 'status', 'status': status}),
      );
      if (response.statusCode != 200 && response.statusCode != 201) return false;
      // 여기에서 State에 저장
      return true;
    } catch (error) {
      return false;
    }
  }
}
