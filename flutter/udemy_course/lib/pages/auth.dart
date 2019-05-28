import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue;
  String _passwordValue;
  bool _acceptTerms = false;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
      image: AssetImage('assets/1.jpeg'),
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'E-Mail',
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (String value) {
        setState(() {
          _emailValue = value;
        });
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          _passwordValue = value;
        });
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _acceptTerms,
      title: Text('약관 동의'),
      onChanged: (bool value) {
        setState(() {
          _acceptTerms = value;
        });
      },
    );
  }

  void _submitForm(Function login) {
    //print(_emailValue);
    //print(_passwordValue);
    login(_emailValue, _passwordValue);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        /*margin: EdgeInsets.all(10.0),*/
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildEmailTextField(),
                SizedBox(height: 10.0),
                _buildPasswordTextField(),
                _buildAcceptSwitch(),
                SizedBox(
                  height: 10.0,
                ),
                ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget widget, MainModel model) {
                  return RaisedButton(
                    child: Text('LOGIN'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    //onPressed: _submitForm,
                    onPressed: () => _submitForm(model.login),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
