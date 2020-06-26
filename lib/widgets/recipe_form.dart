import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:mealmanager/models/models.dart';
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
  final ingredientAmountValidationText = 'Please enter a decimal amount';
  final ingredientsValidationText = 'Please enter an ingredient';

  final stepsHint = 'Write the next step';
  final stepsValidationText = 'Please enter a step';

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
      return _buildIngredientField(
          _uuid.v1(),
          i,
          recipe,
          recipe.ingredients[i].amount,
          recipe.ingredients[i].unit,
          recipe.ingredients[i].text);
    });

    var stepFieldList = List.generate(recipe.steps.length, (i) {
      return _buildStepField(
          _uuid.v1(), i, recipe, stepsHint, stepsValidationText,
          initialValue: recipe.steps[i]);
    });

    return Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
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
                              AddIngredientEvent(
                                  recipe: recipe,
                                  ingredient: new Ingredient.withInitialValues(
                                      1.0, 'x', '')));
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
            )));
  }

  Widget _buildIngredientField(String key, int listIndex, Recipe recipe,
      double initialAmount, String initialUnit, String initialText) {
    return Row(
      key: Key(key),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            child: TextFormField(
          initialValue: initialAmount.toString(),
          decoration: InputDecoration(hintText: 'Amount'),
          keyboardType: TextInputType.number,
          onChanged: (amount) {
            recipe.ingredients[listIndex].amount = double.tryParse(amount);
          },
          onSaved: (amount) {
            recipe.ingredients[listIndex].amount = double.tryParse(amount);
          },
          validator: (value) {
            if (double.tryParse(value) == null) {
              return ingredientAmountValidationText;
            }
            return null;
          },
        )),
        Expanded(
            child: TextFormField(
          initialValue: initialUnit,
          decoration: InputDecoration(hintText: 'Unit'),
          onChanged: (unit) {
            recipe.ingredients[listIndex].unit = unit;
          },
          onSaved: (unit) {
            recipe.ingredients[listIndex].unit = unit;
          },
        )),
        Expanded(
            child: TextFormField(
          initialValue: initialText,
          decoration: InputDecoration(hintText: ingredientsHint),
          onChanged: (text) {
            recipe.ingredients[listIndex].text = text;
          },
          onSaved: (text) {
            recipe.ingredients[listIndex].text = text;
          },
          validator: (value) {
            if (value.isEmpty) {
              return ingredientsValidationText;
            }
            return null;
          },
        )),
        RaisedButton(
          child: Icon(Icons.remove),
          color: Colors.red,
          textColor: Colors.white,
          shape: CircleBorder(side: BorderSide.none),
          onPressed: () {
            BlocProvider.of<RecipeBloc>(context).add(RemoveIngredientEvent(
                recipe: recipe, ingredientIndex: listIndex));
          },
        )
      ],
    );
  }

  // ToDo: update ingredient part of form with number keyboard text form for amount and
  // text form for unit
  Widget _buildStepField(String key, int listIndex, Recipe recipe, String hint,
      String validationText,
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
              recipe.steps[listIndex] = text;
            },
            onSaved: (text) {
              recipe.steps[listIndex] = text;
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
            BlocProvider.of<RecipeBloc>(context)
                .add(RemoveStepEvent(recipe: recipe, stepIndex: listIndex));
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
