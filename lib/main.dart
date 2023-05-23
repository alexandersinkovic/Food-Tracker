import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rating_widget.dart';
import 'details_page.dart';
import 'insert_page.dart';

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
        home: FoodTrackerPage(),
      ),
    );
  }
}

class FoodTrackerState extends ChangeNotifier {
  var displayedFood = ['Food1', 'Food2', 'Food3', 'Food4', 'Food5'];
  var description =
      'Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elite Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore Magna Aliqua Ut Enim Ad Minim Veniam Quis Nostrud Exercitation Ullamco Laboris Nisi Ut Aliquip Ex Ea Commodo Consequat Duis Aute Irure Dolor In Reprehenderit In Voluptate Velit Esse Cillum Dolore Eu Fugiat Nulla Pariatur Excepteur Sint Occaecat Cupidatat Non Proident Sunt In Culpa Qui Officia Deserunt Mollit Anim Id Est Laborum Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elite Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore Magna Aliqua Ut Enim Ad Minim Veniam Quis';
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
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InsertFood(),
          ));
        },
        shape: CircleBorder(),
        backgroundColor: Color.fromARGB(255, 25, 216, 254),
        child: Icon(Icons.add),
      ),
    );
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
