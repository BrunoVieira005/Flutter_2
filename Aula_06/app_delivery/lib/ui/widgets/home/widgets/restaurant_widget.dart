// importa as bibliotecas
import 'package:app_delivery/model/restaurant.dart';
import 'package:app_delivery/ui/widgets/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RestaurantWidget extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantWidget({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Restaurantscreen(restaurant: restaurant);
          }));
        },
        child: Row(
          children: [
            Image.asset(
              'assets/${restaurant.imagePath}',
              width: 72,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(restaurant.name,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                    children: List.generate(restaurant.stars.toInt(), (index) {
                  return Image.asset(
                    'assets/others/star.png',
                    width: 16,
                  );
                })),
                Text('${restaurant.distance} Km')
              ],
            )
          ],
        ),
      ),
    );
  }
}
