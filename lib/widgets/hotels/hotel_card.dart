import 'package:flutter/material.dart';

import '../../models/hotel.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  HotelCard(this.hotel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Pressed');
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(hotel.name, style: TextStyle(
                    fontSize: 22,
                  ),),
                  Text('\$${hotel.price.toString()}', style: TextStyle(
                    fontSize: 18,
                  ),),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: 10.0),),
              Text(hotel.city)
            ],
          ),
        )
      ),
    );
  }
}