import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

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
  final Map<String, dynamic> _formData = {"status": null, "title": null, "description": null, "imageUrl": null, "price": 0.0};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<Map<String, dynamic>> _getInitProduct() async {
    if (widget.act == "new") {
      _formData["status"] = "대기중";
      _formData["title"] = "";
      _formData["description"] = "";
      _formData["imageUrl"] = "";
      _formData["price"] = 0.0;
    }

    if (widget.act == "modify") {
      final http.Response response = await http.get("https://express.datafirst.co.kr/restful/products/${widget.selectedId}");
      var row = json.decode(response.body);
      _formData["status"] = row["status"];
      _formData["title"] = row["title"];
      _formData["description"] = row["description"];
      _formData["imageUrl"] = row["imageUrl"];
      _formData["price"] = double.parse(row["price"]);
    }

    return _formData;
  }

  Widget _buildTitleTextField(String value) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: "제품명"),
      textInputAction: TextInputAction.next,
      validator: (String value) {
        if (value.trim().length == 0) {
          return "제품명은 필수 입력사항 입니다.";
        }
        return null;
      },
      onSaved: (String value) {
        _formData["title"] = value;
      },
    );
  }

  Widget _buildDescriptionTextField(String value) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: "설명"),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      onSaved: (String value) {
        _formData["description"] = value;
      },
    );
  }

  Widget _buildPriceTextField(double value) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(labelText: "가격"),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return "가격은 필수 입력사항 입니다.";
        }
        if (double.tryParse(value) == null) {
          return "가격은 숫자만 입력할 수 있습니다.";
        }
        return null;
      },
      onSaved: (String value) {
        _formData["price"] = double.parse(value);
      },
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.save),
          SizedBox(width: 4),
          Text("Save"),
        ],
      ),
      onPressed: () {
        _submitForm(context);
      },
    );
  }

  void _submitForm(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    if (widget.act == "new") {
      if (await _postProduct()) {
        Navigator.pushReplacementNamed(context, "/product"); // (새로 고침)
      } else {
        print("오류 안내");
      }
    }

    if (widget.act == "modify") {
      if (await _putProduct()) {
        Navigator.pushReplacementNamed(context, "/product"); // (새로 고침)
      } else {
        print("오류 안내");
      }
    }
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
                Navigator.pop(context); // 닫기 버튼 클릭 (저장하지 않고 그냥 닫음)
              },
            );
          },
        ),
        title: Text(widget.act.toUpperCase()),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getInitProduct(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      _buildTitleTextField(snapshot.data["title"]),
                      SizedBox(height: 8),
                      _buildDescriptionTextField(snapshot.data["description"]),
                      SizedBox(height: 8),
                      _buildPriceTextField(snapshot.data["price"]),
                      SizedBox(height: 8),
                      _buildSaveButton(context),
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

  Future<bool> _postProduct() async {
    try {
      final http.Response response = await http.post(
        'https://express.datafirst.co.kr/restful/products',
        headers: {"Content-Type": "application/json"},
        body: json.encode(_formData),
      );
      var responseBody = json.decode(response.body);
      return responseBody["result"];
    } catch (error) {
      return false;
    }
  }

  Future<bool> _putProduct() async {
    try {
      final http.Response response = await http.put(
        'https://express.datafirst.co.kr/restful/products/${widget.selectedId}',
        headers: {"Content-Type": "application/json"},
        body: json.encode(_formData),
      );
      var responseBody = json.decode(response.body);
      return responseBody["result"];
    } catch (error) {
      return false;
    }
  }
}
