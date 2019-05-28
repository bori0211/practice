import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped-models/main.dart';
import '../widgets/form_inputs/image.dart';

class ProductFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductFormPage();
  }
}

class _ProductFormPage extends State<ProductFormPage> {
  final Map<String, dynamic> _formData = {'title': null, 'description': null, 'price': 0, 'image': 'assets/4.png'};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextFiled(Product product) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Product Title',
      ),
      initialValue: product == null ? '' : product.title,
      validator: (String value) {
        if (value.trim().length == 0) {
          return 'Title is required';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextFiled(Product product) {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Product Description',
      ),
      initialValue: product == null ? '' : product.description,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description is required';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextFiled(Product product) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Product Price',
      ),
      initialValue: product == null ? '' : product.price.toString(),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price is required';
        }
        /*if (RegExp) {
          return 'Price should be a Number';
        }*/
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  void _submitForm(Function addProduct, Function updateProduct, Function setSelectedProduct, [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/products').then((_) => setSelectedProduct(null));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Something went wrong'),
                content: Text('Please try again'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
        }
      });
    } else {
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((_) => Navigator.pushReplacementNamed(context, '/products').then((_) => setSelectedProduct(null)));
    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          child: Text('Save'),
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
          onPressed: () => _submitForm(model.addProduct, model.updateProduct, model.selectProduct, model.selectedProductIndex),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        final Widget pageContent = GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  _buildTitleTextFiled(model.selectedProduct),
                  _buildDescriptionTextFiled(model.selectedProduct),
                  _buildPriceTextFiled(model.selectedProduct),
                  SizedBox(height: 10.0),
                  ImageInput(),
                  SizedBox(height: 10.0),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        );

        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
