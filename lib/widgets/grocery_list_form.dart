import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:mealmanager/models/models.dart';
import 'package:mealmanager/blocs/blocs.dart';

class GroceryListForm extends StatefulWidget {
  @override
  GroceryListFormState createState() {
    return GroceryListFormState();
  }
}

class GroceryListFormState extends State<GroceryListForm> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = Uuid();

  final groceryItemHint = 'Enter a new grocery item';
  final groceryItemText = 'Please enter a grocery item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Grocery List Form'),
          leading: BackButton(),
        ),
        body: BlocBuilder<GroceryListBloc, GroceryListState>(
            builder: (context, state) {
          if (state is GroceryListLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GroceryListLoaded) {
            return _buildForm(state.groceryList);
          }
          if (state is GroceryListError) {
            return Center(
                child: Text('Something went wrong!',
                    style: TextStyle(color: Colors.red)));
          }
        }));
  }

  Widget _buildForm(GroceryList groceryList) {
    var itemList = List.generate(groceryList.items.length, (i) {
      return _buildSubField(
          _uuid.v1(), i, groceryList, groceryItemHint, groceryItemText,
          initialValue: groceryList.items[i].item);
    });

    return Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Text(
                  'Name',
                  style: TextStyle(fontSize: 20),
                ),
                TextFormField(
                  initialValue: groceryList.name,
                  decoration: InputDecoration(
                      hintText: 'Enter the grocery list name here'),
                  onSaved: (String value) {
                    groceryList.name = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a name.';
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
                        'Grocery Items',
                        style: TextStyle(fontSize: 20),
                      ),
                      RaisedButton(
                        child: Icon(Icons.add),
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        onPressed: () {
                          BlocProvider.of<GroceryListBloc>(context).add(
                              AddGroceryItemEvent(
                                  groceryList: groceryList,
                                  groceryItem: new GroceryItem()));
                        },
                      )
                    ],
                  ),
                ),
                Column(
                  children: itemList,
                ),
                Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: RaisedButton(
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (groceryList.id == null) {
                              groceryList.dateAdded = DateTime.now();
                              _insertNewGroceryList(context, groceryList);
                            } else {
                              _updateGroceryList(context, groceryList);
                            }
                          }
                        },
                        child: Text('Submit')))
              ],
            )));
  }

  Widget _buildSubField(String key, int listIndex, GroceryList groceryList,
      String hint, String validationText,
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
              groceryList.items[listIndex].item = text;
            },
            onSaved: (text) {
              groceryList.items[listIndex].item = text;
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
            BlocProvider.of<GroceryListBloc>(context).add(
                RemoveGroceryItemEvent(
                    groceryList: groceryList, groceryItemIndex: listIndex));
          },
        )
      ],
    );
  }

  _insertNewGroceryList(BuildContext context, GroceryList groceryList) async {
    BlocProvider.of<GroceryHubBloc>(context)
        .add(AddGroceryListEvent(groceryList: groceryList));
    Navigator.pop(context, groceryList.id);
  }

  _updateGroceryList(BuildContext context, GroceryList groceryList) async {
    BlocProvider.of<GroceryHubBloc>(context)
        .add(EditGroceryListEvent(groceryList: groceryList));
    Navigator.pop(context, groceryList.id);
  }
}
