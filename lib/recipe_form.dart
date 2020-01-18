import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mealmanager/recipe_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class RecipeFormHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Recipe'),
        leading: BackButton(),
      ),
      body: Container(padding: EdgeInsets.all(18.0), child: RecipeForm()),
    );
  }
}

class RecipeForm extends StatefulWidget {
  @override
  RecipeFormState createState() {
    return RecipeFormState();
  }
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = Uuid();
  final titleController = new TextEditingController();

  Database database;
  List<Widget> _ingredientFieldList = new List<Widget>();
  List<Widget> _stepFieldList = new List<Widget>();

  Recipe _recipe = new Recipe();

  @override
  void initState() {
    _initDb();
    super.initState();
  }

  Future<void> _initDb() async {
    var dbPath = await getDatabasesPath();
    await Directory(dbPath).create(recursive: true);

    database = await openDatabase(join(dbPath, 'meal_manager.db'));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Text(
              'Title',
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              controller: titleController,
              decoration:
                  InputDecoration(hintText: 'Enter the recipe title here'),
              onSaved: (String value) {
                _recipe.title = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a title.';
                }
                return null;
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 20),
                  ),
                  RaisedButton(
                    child: Icon(Icons.add),
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        String key = _uuid.v1();
                        _ingredientFieldList.add(_buildSubField(
                            key,
                            'Write a new ingredient',
                            'Please enter an ingredient',
                            'ingredients'));
                      });
                    },
                  )
                ],
              ),
            ),
            Column(
              children: _ingredientFieldList,
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Steps',
                    style: TextStyle(fontSize: 20),
                  ),
                  RaisedButton(
                    child: Icon(Icons.add),
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        String key = _uuid.v1();
                        _stepFieldList.add(_buildSubField(
                            key,
                            'Write the next step',
                            'Please enter a step',
                            'steps'));
                      });
                    },
                  )
                ],
              ),
            ),
            Column(
              children: _stepFieldList,
            ),
            Container(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _insertNewRecipe(context);
                      }
                    },
                    child: Text('Submit')))
          ],
        ));
  }

  Widget _buildSubField(
      String key, String hint, String validationText, String fieldList) {
    return Row(
      key: Key(key),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(hintText: hint),
            validator: (value) {
              if (value.isEmpty) {
                return validationText;
              }
              return null;
            },
          ),
        ),
        RaisedButton(
          child: Icon(Icons.remove),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              if (fieldList == "ingredients") {
                _ingredientFieldList
                    .removeWhere((form) => form.key == Key(key));
              } else {
                _stepFieldList.removeWhere((form) => form.key == Key(key));
              }
            });
          },
        )
      ],
    );
  }

  _insertNewRecipe(BuildContext context) async {
    int id = await database
        .rawInsert('INSERT INTO Recipe(title) VALUES (?)', [_recipe.title]);
    Navigator.pop(context, id);
  }
}
