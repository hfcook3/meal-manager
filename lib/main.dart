import 'package:flutter/material.dart';

void main() => runApp(MealManager());

class MealManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Manager',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MealList(),
    );
  }
}

class MealListState extends State<MealList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meal Manager'),
        ),
        body: Center(
          child: Text('Helloooo World'),
        ));
  }
}

class MealList extends StatefulWidget {
  @override
  MealListState createState() => MealListState();
}
