import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductFormScreen extends StatefulWidget {
  final String act;
  final int selectedId;

  ProductFormScreen(this.act, this.selectedId);

  @override
  State<StatefulWidget> createState() {
    return _ProductFormScreenState();
  }
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final Map<String, dynamic> _formData = {'status': null, 'title': null, 'description': null, 'imageUrl': null, 'price': 0.0};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print('_FormPageState: ${widget.selectedId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // 닫기 버튼 클릭 (저장하지 않고 그냥 닫음)
                Navigator.pop(context);
              },
            );
          },
        ),
        /*title: Text('폼 (등록/수정)'),*/
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              print('save');
              _submitForm(context);
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: _getInitProduct(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text('Loading...'),
              );
            } else {
              return Container(
                margin: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      _buildTitleTextField(snapshot.data['title']),
                      SizedBox(height: 10.0),
                      _buildDescriptionTextField(snapshot.data['description']),
                      SizedBox(height: 10.0),
                      _buildPriceTextField(snapshot.data['price']),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTitleTextField(String value) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '제품명',
        border: OutlineInputBorder(),
      ),
      initialValue: value,
      /*validator: (String value) {
        if (value.trim().length == 0) {
          return '제품명은 필수 입력사항 입니다.';
        }
      },*/
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField(String value) {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
        labelText: '설명',
        border: OutlineInputBorder(),
      ),
      initialValue: value,
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextField(double value) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '가격',
        border: OutlineInputBorder(),
      ),
      initialValue: value.toString(),
      /*validator: (String value) {
        if (value.trim().length == 0) {
          return '가격은 필수 입력사항 입니다.';
        }
      },*/
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  void _submitForm(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    if (widget.act == 'new') {
      if (await _postProduct()) {
        //Navigator.pop(context, true); // 리스트로
        Navigator.pushReplacementNamed(context, "/product"); // (새로 고침)
      } else {
        print('오류 안내');
      }
    }

    if (widget.act == 'modify') {
      if (await _putProduct()) {
        //Navigator.pop(context, true); // 리스트로
        Navigator.pushReplacementNamed(context, "/product"); // (새로 고침)
      } else {
        print('오류 안내');
      }
    }
  }

  Future<Map<String, dynamic>> _getInitProduct() async {
    if (widget.act == 'new') {
      _formData['status'] = '대기중';
      _formData['title'] = 'Default Title';
      _formData['description'] = '';
      _formData['imageUrl'] = '';
      _formData['price'] = 99.99;
    }

    if (widget.act == 'modify') {
      var data = await http.get('https://express.datafirst.co.kr/restful/products/${widget.selectedId}');
      var row = json.decode(data.body);
      //_formData = {'title': row['title'], 'description': row['description'], 'imageUrl': row['imageUrl'], 'price': double.parse(row['price'])};
      _formData['status'] = row['status'];
      _formData['title'] = row['title'];
      _formData['description'] = row['description'];
      _formData['imageUrl'] = row['imageUrl'];
      _formData['price'] = double.parse(row['price']);
    }

    return _formData;
  }

  Future<bool> _postProduct() async {
    try {
      //print(json.encode(_formData));
      final http.Response response = await http.post(
        'https://express.datafirst.co.kr/restful/products',
        headers: {"Content-Type": "application/json"},
        body: json.encode(_formData),
      );
      if (response.statusCode != 200 && response.statusCode != 201) return false;
      // 여기에서 State에 저장
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> _putProduct() async {
    try {
      //print(json.encode(_formData));
      final http.Response response = await http.put(
        'https://express.datafirst.co.kr/restful/products/${widget.selectedId}',
        headers: {"Content-Type": "application/json"},
        body: json.encode(_formData),
      );
      if (response.statusCode != 200 && response.statusCode != 201) return false;
      // 여기에서 State에 저장
      return true;
    } catch (error) {
      return false;
    }
  }
}
