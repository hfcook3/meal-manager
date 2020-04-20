import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mealmanager/models/models.dart';
import 'package:mealmanager/widgets/grocery_list_form.dart';
import 'package:mealmanager/widgets/widgets.dart';
import 'package:mealmanager/blocs/blocs.dart';

import 'grocery_list_view.dart';

class GroceryListHub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery Lists'),
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
      drawer: TopLevelDrawer(
        callingWidget: DrawerWidgets.groceryLists,
      ),
      body: BlocBuilder<GroceryHubBloc, GroceryHubState>(
          builder: (context, state) {
        if (state is GroceryHubEmpty) {
          return Center(
              child: Text('No grocery lists found. Try adding some!'));
        }
        if (state is GroceryHubLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is GroceryHubLoaded) {
          return _buildGroceryLists(state.groceryLists);
        }
        if (state is GroceryHubError) {
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
          BlocProvider.of<GroceryListBloc>(context)
              .add(InitializeNewGroceryListEvent());
          await Navigator.push(context,
              new MaterialPageRoute(builder: (context) => GroceryListForm()));
        },
      ),
    );
  }

  Widget _buildGroceryLists(List<GroceryList> groceryLists) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: groceryLists.length * 2,
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) {
          return Divider(
            thickness: 2.0,
          );
        } else {
          return _buildGroceryTile(context, groceryLists[i ~/ 2]);
        }
      },
    );
  }

  Widget _buildGroceryTile(BuildContext context, GroceryList groceryList) {
    return ListTile(
        title: Center(child: Text(groceryList.name)),
        trailing: PopupMenuButton<String>(
            onSelected: (String result) async {
              switch (result) {
                case 'Delete':
                  {
                    BlocProvider.of<GroceryHubBloc>(context)
                        .add(DeleteGroceryListEvent(groceryList: groceryList));
                  }
                  break;
                case 'Edit':
                  {
                    BlocProvider.of<GroceryListBloc>(context)
                        .add(GetFullGroceryListEvent(groceryList: groceryList));
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroceryListForm()));
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
            BlocProvider.of<GroceryListBloc>(context)
                .add(GetFullGroceryListEvent(groceryList: groceryList));
            return GroceryListView();
          }));
        });
  }
}
