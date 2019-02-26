import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../scope-models/main.dart';

class HotelCreateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotelCreateScreenState();
  }
}

class _HotelCreateScreenState extends State<HotelCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  ProgressDialog _displayDialog;
  String _name;
  String _city;
  double _price;

  @override
  Widget build(BuildContext context) {
    _displayDialog = ProgressDialog(context);

    return Scaffold(
      appBar: AppBar(title: Text('Create hotel'),),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildNameField(),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
                _buildCityField(),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
                _buildPriceField(),
                Padding(padding: const EdgeInsets.symmetric(vertical: 20.0),),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      autofocus: true,
      textInputAction: TextInputAction.next,
      focusNode: _nameFocusNode,
      decoration: InputDecoration(
        hintText: 'Hotel name',
        labelText: 'Hotel name',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Hotel name is required';
        }
      },
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(_cityFocusNode);
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      focusNode: _cityFocusNode,
      decoration: InputDecoration(
        hintText: 'Hotel city',
        labelText: 'Hotel city',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Hotel city is required';
        }
      },
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(_priceFocusNode);
      },
      onSaved: (String value) {
        _city = value;
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      focusNode: _priceFocusNode,
      decoration: InputDecoration(
        hintText: 'Hotel price',
        labelText: 'Hotel price',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Hotel price is required';
        }
      },
      onFieldSubmitted: (String value) {
        _priceFocusNode.unfocus();
      },
      onSaved: (String value) {
        _price = double.parse(value);
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          child: Text('Create'),
          textColor: Colors.white,
          onPressed: () => _onSubmit(model.createHotel),
        );
      },
    );
  }

  void _onSubmit(Function createHotel) async {
    if (!_formKey.currentState.validate()) return;

    _displayDialog.show();
    try {
      _formKey.currentState.save();
      await createHotel(_name, _city, _price);
      Navigator.pushNamed(context, '/home');
      _displayDialog.hide();
    } catch (err) {
      print(err);
      _displayDialog.hide();
    }
  }
}