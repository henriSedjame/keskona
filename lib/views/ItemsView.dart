import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:keskona/models/Item.dart';
import 'package:keskona/repository/ItemRepository.dart';
import 'package:keskona/views/AddItemView.dart';

import 'ItemView.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({Key? key}) : super(key: key);

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  late ItemRepository _repository;

  final List<Item> _items = <Item>[];

  @override
  void initState() {
    super.initState();
    _repository = GetIt.instance.get<ItemRepository>();

    init();
  }

  Future<void> init() async {
    await _repository.init();
    refresh();
  }

  Future<void> refresh() async {
    _items.clear();
     _repository
        .findAll()
        .then((items) => setState(() => _items.addAll(items!)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Row(
          children: const [
              SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: Image(image: AssetImage("assets/logo.png"), fit: BoxFit.cover)),
             Padding(
               padding: EdgeInsets.only(left: 15.0),
               child: Text("K'ESKÔNA?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34.0),
            ),
             ),
          ],
        )),
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            shrinkWrap: true,
            children: _items
                .map((item) => ItemView(
                      item,
                      updateItem: update,
                      deleteItem: delete,
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          add();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void add() async {
    showDialog<Item>(
        context: context,
        builder: (BuildContext ctx) {
          return AddItemView();
        }).then((item) => {
          if (item != null)
            {
              _repository
                  .addItem(item)
                  .then((value) => {setState(() => _items.add(value))})
            }
        });
  }

  void update(Item item) async {
    if (item.quantity == 0) {
      delete(item);
    }
    _repository.update(item.id, item.quantity).then((updated) {
      if (updated) {
        setState(() => _items.map((i) {
              if (i.id == item.id) {
                return item;
              } else {
                return i;
              }
            }));
      }
    });
  }

  void delete(Item item) async {
    _repository.delete(item.id).then((deleted) {
      if (deleted) {
        setState(() {
          _items.retainWhere((e) => e.id != item.id);
        });
      }
    });
  }
}
