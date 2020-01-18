import 'package:flutter/material.dart';
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

  List<Widget> _ingredientFieldList = List<Widget>();
  List<Widget> _stepFieldList = List<Widget>();

  @override
  void initState() {
    _ingredientFieldList = [_buildIngredientField(_uuid.v1())];
    _stepFieldList = [_buildStepField(_uuid.v1())];
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
              decoration:
                  InputDecoration(hintText: 'Enter the recipe title here'),
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
                        _ingredientFieldList
                            .add(_buildIngredientField(_uuid.v1()));
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
                        _stepFieldList.add(_buildStepField(_uuid.v1()));
                      });
                    },
                  )
                ],
              ),
            ),
            Column(
              children: _stepFieldList,
            ),
            RaisedButton(
                color: Colors.deepPurple,
                textColor: Colors.white,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'))
          ],
        ));
  }

  Widget _buildIngredientField(String key) {
    return Row(
      key: Key(key),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
                hintText: 'Enter an ingredient for your recipe'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter an ingredient.';
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
              _ingredientFieldList.removeWhere((form) => form.key == Key(key));
            });
          },
        )
      ],
    );
  }

  Widget _buildStepField(String key) {
    return Row(
      key: Key(key),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            decoration:
                InputDecoration(hintText: 'Enter the next step in your recipe'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a step.';
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
              _ingredientFieldList.removeWhere((form) => form.key == Key(key));
            });
          },
        )
      ],
    );
  }
}
