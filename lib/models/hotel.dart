import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  final String id;
  final String name;
  final String city;
  final double price;

  Hotel(this.id, this.name, this.city, this.price);

  Hotel.fromMap(Map<String, dynamic> map, { this.id })
    : assert(map['name'] != null),
      assert(map['city'] != null),
      assert(map['price'] != null),
      name = map['name'],
      city = map['city'],
      price = double.parse(map['price']);

  Hotel.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, id: snapshot.reference.toString());
}