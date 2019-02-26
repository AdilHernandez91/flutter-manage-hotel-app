import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../scope-models/main.dart';
import '../models/hotel.dart';
import '../widgets/hotels/hotel_card.dart';

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
        padding: const EdgeInsets.all(15.0),
        child: _buildStreamList(),
      )
    );
  }

  Widget _buildStreamList() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return StreamBuilder<QuerySnapshot>(
          stream: model.getHotelList(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator(),);

            return _buildHotelList(snapshot.data.documents);
          },
        );
      },
    );
  }

  Widget _buildHotelList(List<DocumentSnapshot> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        Hotel hotel = Hotel.fromSnapshot(data[index]);
        return HotelCard(hotel);
      },
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
              ),
              ListTile(
                trailing: Icon(Icons.arrow_forward),
                title: Text('Create hotel'),
                leading: Icon(Icons.edit),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/hotels/create');
                },
              ),
              Divider(),
              ListTile(
                trailing: Icon(Icons.arrow_forward),
                title: Text('Manage hotels'),
                leading: Icon(Icons.hotel),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/hotels/manage');
                },
              ),
              Divider(),
              ListTile(
                trailing: Icon(Icons.arrow_forward),
                title: Text('Settings'),
                leading: Icon(Icons.settings),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}