import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mealmanager/blocs/recipe_list_bloc.dart';
import 'package:mealmanager/models/recipe_model.dart';
import 'package:mealmanager/widgets/widgets.dart';
import 'package:mealmanager/blocs/blocs.dart';

class RecipeListViewState extends State<RecipeListView> {
  @override
  void initState() {
    _initState();
    super.initState();
  }

  Future<void> _initState() async {
    BlocProvider.of<RecipeListBloc>(context).add(GetRecipeListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Manager'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext buildContext) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem(value: 'Delete', child: Text('Delete'))
              ];
            },
          )
        ],
      ),
      body: BlocBuilder<RecipeListBloc, RecipeListState>(
          builder: (context, state) {
        if (state is RecipeListEmpty) {
          return Center(child: Text('No recipes found. Try adding some!'));
        }
        if (state is RecipeListLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is RecipeListLoaded) {
          return _buildRecipes(state.recipeList);
        }
        if (state is RecipeListError) {
          return Center(
              child: Text('Something went wrong!',
                  style: TextStyle(color: Colors.red)));
        }
        return Center(
            child: Text('Bad state.', style: TextStyle(color: Colors.red)));
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await _navigateAndGetResult(context);
          BlocProvider.of<RecipeListBloc>(context).add(GetRecipeListEvent());
        },
      ),
    );
  }

  Future<void> _navigateAndGetResult(BuildContext context) async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => RecipeFormHome(new Recipe())));
  }

  Widget _buildRecipes(List<Recipe> recipeList) {
    if (recipeList == null || recipeList.length == 0) {
      return Center(
        child: Text("No recipes found. Make some!"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: recipeList.length * 2,
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) {
          return Divider(
            thickness: 2.0,
          );
        } else {
          return _buildRecipeTile(context, recipeList[i ~/ 2]);
        }
      },
    );
  }

  Widget _buildRecipeTile(BuildContext context, Recipe recipe) {
    return ListTile(
        title: Center(child: Text(recipe.title)),
        trailing: PopupMenuButton<String>(
            onSelected: (String result) async {
              switch (result) {
                case 'Delete':
                  {
                    BlocProvider.of<RecipeListBloc>(context)
                        .add(DeleteRecipeEvent(recipe: recipe));
                  }
                  break;
                case 'Edit':
                  {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeFormHome(recipe)));
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext buildContext) =>
                <PopupMenuEntry<String>>[
                  const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                  const PopupMenuItem(value: 'Edit', child: Text('Edit'))
                ]),
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            BlocProvider.of<RecipeBloc>(context)
                .add(GetFullRecipeEvent(recipe: recipe));
            return RecipeView();
          }));
        });
  }
}

class RecipeListView extends StatefulWidget {
  @override
  RecipeListViewState createState() => RecipeListViewState();
}
