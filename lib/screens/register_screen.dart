import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../scope-models/main.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  ProgressDialog _dialog;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    _dialog = ProgressDialog(context);
    _dialog.setMessage('Creating account...');

    return Scaffold(
      appBar: AppBar(title: Text('Create account')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(padding: const EdgeInsets.only(top: 40.0),),
                  _buildEmailField(),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
                  _buildPasswordField(),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 25.0),),
                  _buildSubmitButton(),
                ],
              ),
            ),
          )
        ),
      )
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Email address',
        labelText: 'Email address',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email address is required';
        }
      },
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(_passwordFocus);
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      focusNode: _passwordFocus,
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: 'Password',
        labelText: 'Password',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }

        if (value.isNotEmpty && value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
      },
      onFieldSubmitted: (String value) {
        _passwordFocus.unfocus();
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return RaisedButton(
            child: Text('Sign Up'),
            textColor: Colors.white,
            onPressed: () => _onSubmit(model.signUp),
          );
        }
    );
  }

  void _onSubmit(Function signUp) async {
    if (!_formKey.currentState.validate()) return;

    _dialog.show();

    try {
      _formKey.currentState.save();
      await signUp(_email, _password);
      _dialog.hide();
      Navigator.pushReplacementNamed(context, '/home');
    } catch (err) {
      _dialog.hide();
      _displayAlert(err.message);
    }
  }

  void _displayAlert(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Register failed'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
}

