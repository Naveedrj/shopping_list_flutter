import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/Screens/add_item.dart';
import 'package:shopping_list/model_view/item.dart';
import 'package:shopping_list/model_view/item_view.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  void _loadItems() async {
    final url = Uri.https(
        'shoppinglist-8b152-default-rtdb.firebaseio.com', 'shopping_list.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode the response body
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        items.clear();
        data.forEach((key, value) {
          items.add(Item(
            id: key,
            name: value['name'],
            quantity: int.tryParse(value['quantity'])!, // Handle null or invalid values
            category: value['category'],
          ));
        });
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem()))
              .then((_) {
            _loadItems();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(20, 50, 20, 0)),
            Text('Shopping List',
              style: TextStyle(
                fontSize: 50,
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(items[index]),
                    onDismissed: (direction) async {
                      final url = Uri.https(
                          'shoppinglist-8b152-default-rtdb.firebaseio.com', 'shopping_list/${items[index].id}.json');
                      final response = await http.delete(url);
                      setState(() {
                        items.removeAt(index);
                      });
                    },

                    child: ViewItem(
                      name: items[index].name,
                      quantity: items[index].quantity,
                      category: items[index].category,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
