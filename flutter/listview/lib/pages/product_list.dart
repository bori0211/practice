import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
}

class _ProductListState extends State<ProductList> {
  List<String> dogImages = new List();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();

    fetchFive();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchFive();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AAAA'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: dogImages.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            constraints: BoxConstraints.tightFor(height: 150.0),
            child: Image.network(dogImages[index], fit: BoxFit.fitWidth),
          );
        },
      ),
    );
  }

  fetch() async {
    Client client = Client();

    final response = await client.get('https://dog.ceo/api/breeds/image/random');
    if (response.statusCode == 200) {
      setState(() {
        dogImages.add(json.decode(response.body)['message']);
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  fetchFive() {
    for (int i = 0; i < 5; i++) {
      fetch();
    }
  }
}
