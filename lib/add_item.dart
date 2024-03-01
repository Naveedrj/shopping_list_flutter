import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_list/item.dart';

import 'package:http/http.dart' as http ;

class AddItem extends StatefulWidget {

  const AddItem({
    Key , key,
  }) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  List<String> categoryList = [
    'Groceries',
    'Electronics',
    'Clothing',
    'Books',
    'Home Decor',
    'Toys',
    'Health & Beauty',
    'Sports & Outdoors',
    'Automotive',
    'Pet Supplies',
  ];
  String? _selectedCategory;
  var _nameController = TextEditingController();
  var _quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _saveItem(){
     if( _formKey.currentState!.validate()){
       final url = Uri.http('shoppinglist-8b152-default-rtdb.firebaseio.com' , 'shopping_list.json' );
       http.post(
         url ,
         headers: {
           'Content-Type' : 'application/json'
         },
         body: json.encode({
           'name' : _nameController.text,
           'quantity' : _quantityController.text,
           'category' : _selectedCategory
         })
       );
     }
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _quantityController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                  ),
                  validator: (value){
                    if(value == null || value.trim().length >25 || value.trim().length < 1 ){
                      return 'Length must be between 1-25';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                        ),
                        validator: (value){
                          if (value == null || int.tryParse(value) == null || int.tryParse(value)! < 1) {
                            return 'Please enter valid quantity';
                          }
                        return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      items: categoryList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _saveItem,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
