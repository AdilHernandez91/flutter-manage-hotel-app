import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scope-models/main.dart';

class HomeScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}


class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text('Hotel List'),
        actions: <Widget>[
          _buildSignOut(),
        ],
      ),
      body: Container(
        child: Center(
          child: Text('Home Screen'),
        ),
      )
    );
  }

  Widget _buildSignOut() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await model.signOut();
            Navigator.pushReplacementNamed(context, '/');
          },
        );
      },
    );
  }

  Widget _buildDrawer() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text(model.currentUser.email),
                accountName: Text('User account'),
              )
            ],
          ),
        );
      },
    );
  }
}