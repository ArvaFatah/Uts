import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts/Models/Item.dart';
import 'package:uts/Models/kategori.dart';

import 'DbHelper/DbHelper.dart';

class EntryForm extends StatefulWidget {
  final Item item;
  EntryForm(this.item);
  @override
  EntryFormState createState() => EntryFormState(this.item);
}

//class controller
class EntryFormState extends State<EntryForm> {
  Item item;
  EntryFormState(this.item);
  DbHelper dbHelper = DbHelper();
  int countKat = 0;
  String _val = "Kategori";

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  @override
  List<String> _animals = <String>[];
  initState(){
      super.initState();

      loadAnimals();
    }
    
  loadAnimals() async {
    // gets data from sqflite
    final loadedAnimals = await dbHelper.selectKategori();
    setState(() {
      // converts sqflite row data to List<String>, updating state
      _animals = loadedAnimals.toList();
    });
     if (item != null) {
      nameController.text = item.name;
      priceController.text = item.price.toString();
      _val = item.kategori;
      stockController.text = item.stock.toString();
    }
  }

  Widget build(BuildContext context) {
    //kondisi
    
    //rubah
    return Scaffold(
        appBar: AppBar(
          title: item == null ? Text('Tambah') : Text('Ubah'),
          leading: Icon(Icons.keyboard_arrow_left),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
             
              // nama
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nama Barang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              // harga
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              //stock
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              //kategori

              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: DropdownButton<String>(
                    hint: Text(_val),
                    items: _animals.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        _val=newValue;
                      });
                    }),
              ),
              // tombol button
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    // tombol simpan
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (item == null) {
                            // tambah data
                            item = Item(
                                _val,
                                nameController.text,
                                int.parse(priceController.text),
                                int.parse(stockController.text));
                          } else {
                            // ubah data
                            item.name = nameController.text;
                            item.kategori = _val;
                            item.price = int.parse(priceController.text);
                            item.stock = int.parse(stockController.text);
                          }
                          // kembali ke layar sebelumnya dengan membawa objek item
                          Navigator.pop(context, item);
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    // tombol batal
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
