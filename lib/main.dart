import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(FoodTracker());
}

class FoodTracker extends StatelessWidget {
  const FoodTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FoodTrackerState(),
      child: MaterialApp(
        title: 'Food Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        ),
        home: FoodTrackerHomePage(),
      ),
    );
  }
}

class FoodTrackerHomePage extends StatefulWidget {
  const FoodTrackerHomePage({Key? key}) : super(key: key);

  @override
  State<FoodTrackerHomePage> createState() => _FoodTrackerHomePageState();
}

class _FoodTrackerHomePageState extends State<FoodTrackerHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget selectedFood = context.watch<FoodTrackerState>().selectedFood;
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = FoodTrackerPage();
        break;
      case 1:
        page = selectedFood;
        break;
      default:
        throw Exception('Invalid index $selectedIndex');
    }

    return page;
  }
}

class FoodTrackerState extends ChangeNotifier {
  var current = WordPair.random();
  var displayedFood = ['Food1', 'Food2', 'Food3'];
  var description =
      'Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elite Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore Magna Aliqua Ut Enim Ad Minim Veniam Quis Nostrud Exercitation Ullamco Laboris Nisi Ut Aliquip Ex Ea Commodo Consequat Duis Aute Irure Dolor In Reprehenderit In Voluptate Velit Esse Cillum Dolore Eu Fugiat Nulla Pariatur Excepteur Sint Occaecat Cupidatat Non Proident Sunt In Culpa Qui Officia Deserunt Mollit Anim Id Est Laborum Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elite Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore Magna Aliqua Ut Enim Ad Minim Veniam Quis';
  Widget selectedFood = Placeholder();

  void setSelectedFood(Widget food) {
    selectedFood = food;
    notifyListeners();
  }
}

class FoodTrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<FoodTrackerState>();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Food Tracker'),
        ),
        body: Scrollbar(
            child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (var food in appState.displayedFood)
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                child: FoodEntry(
                  food: food,
                  rating: 5,
                  description: appState.description,
                ),
              ),
          ],
        )));
  }
}

class FoodEntry extends StatelessWidget {
  const FoodEntry({
    super.key,
    required this.food,
    required this.rating,
    required this.description,
  });

  final String food;
  final double rating;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        height: 120,
        padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.lightGreenAccent[100],
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FoodDetails(
                  food: food, rating: rating, description: description),
            ));
          },
          child: Row(
            children: [
              Placeholder(
                fallbackHeight: 100,
                fallbackWidth: 100,
              ),
              //Image,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(textScaleFactor: 1.2, food)),
                            FoodRating(rating: rating),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 60,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      description,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class FoodDetails extends StatelessWidget {
  const FoodDetails({
    super.key,
    required this.food,
    required this.rating,
    required this.description,
  });

  final String food;
  final double rating;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Placeholder(
                fallbackHeight: 100,
                fallbackWidth: 100,
              ),
            ),
            Expanded(
              child: Ink(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent[100],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          food,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        FoodRating(rating: rating),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            description,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
