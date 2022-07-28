import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:keskona/models/Item.dart';
import 'package:keskona/views/PositionView.dart';
import 'package:keskona/views/notifiers/ItemViewNotifier.dart';

typedef DoOnItem = void Function(Item);

class ItemView extends StatefulWidget {
  final Item item;
  final DoOnItem updateItem;
  final DoOnItem deleteItem;
  const ItemView(this.item, {required this.updateItem, required this.deleteItem, Key? key}) : super(key: key);

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {

  late ItemViewNotifier _itemViewNotifier;

  bool viewDetail = false;

  late StreamSubscription<String> _subs;
  @override
  void initState() {
    super.initState();
    _itemViewNotifier = GetIt.instance.get<ItemViewNotifier>();

    _subs = _itemViewNotifier.stream.listen((String id) {
      setState(() => viewDetail = id == widget.item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: viewDetail ? selectedView() : unSelectedView(),
    );
  }

  Widget selectedView() {
    return Card(
      color: Colors.amber,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: PositionView(pos: widget.item.position),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15.0,),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.item.category?.icon() ?? "", style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25.0
                        ),),
                        const SizedBox(height: 5.0,),
                        Text(widget.item.label, style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0
                        ),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => updateQty(true),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white, // Background color
                          ),
                          child: const Icon(Icons.add, color: Colors.green,size: 30.0,)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(widget.item.quantity.toString(), style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 50.0
                        ),),
                      ),
                      ElevatedButton(
                          onPressed: () => updateQty(false),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          child: const Icon(Icons.remove, color: Colors.redAccent,size: 30.0,)),
                    ],
                  ),
                  const SizedBox(height: 15.0,),

                ],
              ),
              const SizedBox(width: 20.0,)
            ],
          ),
          if (widget.item.info != null) ... [
            Text(widget.item.info ?? "", style: const TextStyle(
              fontStyle: FontStyle.italic
            ),)
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children:  [
                  const SizedBox(width: 5.0,),
                  const Text("Date de congélation : ", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      fontSize: 15.0
                  ),),
                  const SizedBox(width: 5.0,),
                  Text(widget.item.congelationDate(), style: const TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                  ),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                    onPressed: () => delete(), icon: const Icon(Icons.delete_outline_sharp, color: Colors.red, size: 30.0,)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget unSelectedView() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black, blurRadius: 0.2, offset: Offset(0.0, 0.4))
      ]),
      child: Column(
        children: [
          ListTile(
            style: ListTileStyle.list,
            title: Text(widget.item.label, style: const TextStyle(
              fontWeight: FontWeight.bold
            ),),
            leading: Text(widget.item.category?.icon() ?? "" , style: const TextStyle(fontSize: 30.0)),
            trailing: CircleAvatar(
              child: Text(
                widget.item.quantity.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            onTap: (){
              _itemViewNotifier.select(widget.item.id);
            },
          ),
        ],
      ),
    );
  }

  void updateQty(bool increase) {

    var item = widget.item
        ..quantity = (widget.item.quantity + (increase ? 1 : (- 1)));

    widget.updateItem(item);

  }

  void delete() {
    widget.deleteItem(widget.item);
  }

  @override
  void dispose() {
    super.dispose();
    _subs.cancel();
  }
}
