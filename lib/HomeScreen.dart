import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/add_item.dart';

import 'package:shopping_list/item.dart';
import 'package:shopping_list/item_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Item> items = [
    Item(
      name: 'Soap',
      quantity: 5,
      category: 'Grocery',
    ),
    Item(
      name: 'Milk',
      quantity: 10,
      category: 'Daiey',
    ),
    Item(
      name: 'Fish',
      quantity: 3,
      category: 'Meat',
    ),
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         setState(() async{
           items.add(
               await Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem()))
           );
         });
        },
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context , index){
                return ViewItem(name: items[index].name ,
                    quantity: items[index].quantity,
                    category: items[index].category
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
