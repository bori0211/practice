import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue;
  String _passwordValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: <Widget>[
              _buildEmailTextField(),
              SizedBox(height: 10.0),
              _buildPasswordTextField(),
              SizedBox(height: 10.0),
              _buildSubmitRaisedButton(context),
            ],
          ),
        ),
      ),
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

/*
              RaisedButton(
                child: Text('LOGIN'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () => {},
              ),
*/

  Widget _buildSubmitRaisedButton(BuildContext context) {
    //print(_emailValue);
    //print(_passwordValue);

    return RaisedButton(
      child: Text('LOGIN'),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      //onPressed: _submitForm,
      onPressed: () => Navigator.pushReplacementNamed(context, '/list/판매중'),
    );

    //login(_emailValue, _passwordValue);
    //Navigator.pushReplacementNamed(context, '/products');
  }

  /*void _submitForm() {
    print(_emailValue);
    print(_passwordValue);
    //login(_emailValue, _passwordValue);
    Navigator.pushReplacementNamed(context, '/home');
  }*/
}
