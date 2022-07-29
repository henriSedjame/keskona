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

  TextEditingController searchCtrl = TextEditingController();

  String filter = "";

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                SizedBox(
                    width: 70.0,
                    height: 70.0,
                    child: Image(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.cover)),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "K'ESKÔNA?",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: refresh,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 35.0,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: TextField(
              controller: searchCtrl,
              decoration:  InputDecoration(
                hintText: "Rechercher",
                prefixIcon: const Icon(Icons.search),
                suffix: IconButton(
                    onPressed: () {
                      searchCtrl.clear();
                      setState(()=> filter = "");
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    icon: const Icon(Icons.close, color: Colors.grey,))
              ),
              onChanged: (value) {
                setState(() => filter = value);
              },
            ),
          ),


          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: itemsTiles(),
            ),
          ),
        ],
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

  List<Widget> itemsTiles() {
    List<Widget> list = (_items
          ..sort((item1, item2) => item1.date.compareTo(item2.date)))
          .where((item) => item.label.toLowerCase().contains(filter.toLowerCase()))
          .map((item) => SizedBox(
            child: ItemView(
                  item,
                  updateQtyItem: updateQty,
                  updatePosItem: updatePos,
                  deleteItem: delete,
                ),
          ))
          .toList();
    list.add(const SizedBox(height: 75.0,));
    return list;
  }

  void add() async {
    showDialog<Item>(
        context: context,
        barrierDismissible: false,
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

  void updateQty(Item item) async {
    if (item.quantity == 0) {
      delete(item);
    }
    _repository.updateQty(item.id, item.quantity).then((updated) {
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

  void updatePos(Item item) async {
    _repository.updatePos(item.id, item.position).then((updated) {
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
