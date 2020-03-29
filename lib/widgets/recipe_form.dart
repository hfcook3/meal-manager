import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:mealmanager/models/recipe_model.dart';
import 'package:mealmanager/blocs/blocs.dart';

class RecipeForm extends StatefulWidget {
  @override
  RecipeFormState createState() {
    return RecipeFormState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recipe form'),
          leading: BackButton(),
        ),
        body: BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
          if (state is RecipeLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is RecipeLoaded) {
            return _buildForm(state.recipe);
          }
          if (state is RecipeError) {
            return Center(
                child: Text('Something went wrong!',
                    style: TextStyle(color: Colors.red)));
          }
        }));
  }

  Widget _buildForm(Recipe recipe) {
    var ingredientFieldList = List.generate(recipe.ingredients.length, (i) {
      return _buildSubField(_uuid.v1(), i, recipe, ingredientsHint,
          ingredientsValidationText, ingredientsListName,
          initialValue: recipe.ingredients[i]);
    });

    var stepFieldList = List.generate(recipe.steps.length, (i) {
      return _buildSubField(
          _uuid.v1(), i, recipe, stepsHint, stepsValidationText, stepsListName,
          initialValue: recipe.steps[i]);
    });

    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Text(
              'Title',
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              initialValue: recipe.title,
              decoration:
                  InputDecoration(hintText: 'Enter the recipe title here'),
              onSaved: (String value) {
                recipe.title = value;
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
                      BlocProvider.of<RecipeBloc>(context).add(
                          AddIngredientEvent(recipe: recipe, ingredient: ''));
                    },
                  )
                ],
              ),
            ),
            Column(
              children: ingredientFieldList,
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
                      BlocProvider.of<RecipeBloc>(context)
                          .add(AddStepEvent(recipe: recipe, step: ''));
                    },
                  )
                ],
              ),
            ),
            Column(
              children: stepFieldList,
            ),
            Container(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if (recipe.id == null) {
                          _insertNewRecipe(context, recipe);
                        } else {
                          _updateRecipe(context, recipe);
                        }
                      }
                    },
                    child: Text('Submit')))
          ],
        ));
  }

  Widget _buildSubField(String key, int listIndex, Recipe recipe, String hint,
      String validationText, String fieldList,
      {String initialValue = ''}) {
    return Row(
      key: Key(key),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(hintText: hint),
            onChanged: (text) {
              if (fieldList == "ingredients") {
                recipe.ingredients[listIndex] = text;
              } else if (fieldList == "steps") {
                recipe.steps[listIndex] = text;
              }
            },
            onSaved: (text) {
              if (fieldList == "ingredients") {
                recipe.ingredients[listIndex] = text;
              } else if (fieldList == "steps") {
                recipe.steps[listIndex] = text;
              }
            },
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
            if (fieldList == "ingredients") {
              BlocProvider.of<RecipeBloc>(context).add(RemoveIngredientEvent(
                  recipe: recipe, ingredientIndex: listIndex));
            } else {
              BlocProvider.of<RecipeBloc>(context)
                  .add(RemoveStepEvent(recipe: recipe, stepIndex: listIndex));
            }
          },
        )
      ],
    );
  }

  _insertNewRecipe(BuildContext context, Recipe recipe) async {
    BlocProvider.of<RecipeListBloc>(context)
        .add(AddRecipeEvent(recipe: recipe));
    Navigator.pop(context, recipe.id);
  }

  _updateRecipe(BuildContext context, Recipe recipe) async {
    BlocProvider.of<RecipeListBloc>(context)
        .add(EditRecipeEvent(recipe: recipe));
    Navigator.pop(context, recipe.id);
  }
}
