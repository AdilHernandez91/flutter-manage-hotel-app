import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../scope-models/main.dart';
import '../models/hotel.dart';

class HotelManageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotelManageScreenState();
  }
}

class _HotelManageScreenState extends State<HotelManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Hotels')),
      body: Container(
        child: _buildStreamList(),
      )
    );
  }

  Widget _buildStreamList() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return StreamBuilder<QuerySnapshot>(
          stream: model.getHotelByUser(),
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
      padding: EdgeInsets.all(10.0),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildHotelItem(data[index]);
      },
    );
  }

  Widget _buildHotelItem(DocumentSnapshot data) {
    Hotel hotel = Hotel.fromSnapshot(data);
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(hotel.name),
          subtitle: Text(hotel.city),
          trailing: Icon(Icons.edit),
          onTap: () {},
        ),
        Divider(),
      ],
    );
  }
}