import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FoodRating extends StatefulWidget {
  final double rating;

  const FoodRating({
    super.key,
    required this.rating,
  });

  @override
  State<FoodRating> createState() => _FoodRatingState();
}

class _FoodRatingState extends State<FoodRating> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 2.0, bottom: 2.0),
          child: RatingBarIndicator(
            rating: _rating,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 15.0,
            unratedColor: Colors.amber.withAlpha(50),
          ),
        ),
        Center(
          child: Text(
            _rating.toStringAsFixed(2),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
