import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_model.dart';

mixin HotelModel on Model, AuthModel {
  final Firestore _database = Firestore.instance;

  Future<void> createHotel(String name, String city, double price) async {
    return await _database.collection('hotels').add({
      'name': name,
      'city': city,
      'price': price,
      'user': currentUser.id,
    });
  }

  Stream getHotelByUser() {
    return _database
        .collection('hotels').where('user', isEqualTo: currentUser.id)
        .snapshots();
  }

  Stream getHotelList() {
    return _database.collection('hotels').snapshots();
  }
}