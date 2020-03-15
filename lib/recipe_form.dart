import 'package:flutter/material.dart';
import 'package:mealmanager/recipe_model.dart';
import 'package:mealmanager/repositories/recipe_sql_client.dart';
import 'package:uuid/uuid.dart';

class RecipeFormHome extends StatelessWidget {
  final Recipe recipeToEdit;
  final RecipeSqlClient _recipeSqlClient;

  RecipeFormHome(this.recipeToEdit, this._recipeSqlClient);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Recipe'),
        leading: BackButton(),
      ),
      body: Container(
          padding: EdgeInsets.all(18.0),
          child: RecipeForm(recipeToEdit, _recipeSqlClient)),
    );
  }
}

class RecipeForm extends StatefulWidget {
  final Recipe recipe;
  final RecipeSqlClient _recipeSqlClient;

  RecipeForm(this.recipe, this._recipeSqlClient);

  @override
  RecipeFormState createState() {
    return RecipeFormState(recipe, _recipeSqlClient);
  }
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = Uuid();

  final ingredientsHint = 'Write a new ingredient';
  final ingredientsValidationText = 'Please enter an ingredient';
  final ingredientsListName = 'ingredients';

  final stepsHint = 'Write the next step';
  final stepsValidationText = 'Please enter a step';
  final stepsListName = 'steps';

  RecipeSqlClient _recipeSqlClient;
  List<Widget> _ingredientFieldList = new List<Widget>();
  List<Widget> _stepFieldList = new List<Widget>();

  Recipe _recipe;

  RecipeFormState(this._recipe, this._recipeSqlClient);

  @override
  void initState() {
    if (_recipe.ingredients == null) {
      _recipe.ingredients = new List<String>();
    } else {
      _ingredientFieldList = List.generate(_recipe.ingredients.length, (i) {
        return _buildSubField(_uuid.v1(), ingredientsHint,
            ingredientsValidationText, ingredientsListName,
            initialValue: _recipe.ingredients[i]);
      });
      _recipe.ingredients = new List<String>();
    }

    if (_recipe.steps == null) {
      _recipe.steps = new List<String>();
    } else {
      _stepFieldList = List.generate(_recipe.steps.length, (i) {
        return _buildSubField(
            _uuid.v1(), stepsHint, stepsValidationText, stepsListName,
            initialValue: _recipe.steps[i]);
      });
      _recipe.steps = new List<String>();
    }

    super.initState();
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
              initialValue: _recipe.title,
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
                            ingredientsHint,
                            ingredientsValidationText,
                            ingredientsListName));
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
                        _stepFieldList.add(_buildSubField(key, stepsHint,
                            stepsValidationText, stepsListName));
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
                        if (_recipe.id == null) {
                          _insertNewRecipe(context);
                        } else {
                          _updateRecipe(context);
                        }
                      }
                    },
                    child: Text('Submit')))
          ],
        ));
  }

  Widget _buildSubField(
      String key, String hint, String validationText, String fieldList,
      {String initialValue = ''}) {
    return Row(
      key: Key(key),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(hintText: hint),
            onSaved: ((String value) {
              if (fieldList == "ingredients") {
                _recipe.ingredients.add(value);
              } else {
                _recipe.steps.add(value);
              }
            }),
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
          shape: CircleBorder(side: BorderSide.none),
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
    int id = await _recipeSqlClient.insertRecipe(_recipe);
    Navigator.pop(context, id);
  }

  _updateRecipe(BuildContext context) async {
    _recipeSqlClient.updateRecipe(_recipe);
    Navigator.pop(context, _recipe.id);
  }
}
