import 'package:flutter/material.dart';
import 'package:keskona/models/Item.dart';
import 'package:keskona/models/constants.dart';
import 'package:uuid/uuid.dart';

class AddItemView extends StatefulWidget {
  AddItemView({Key? key}) : super(key: key);

  @override
  State<AddItemView> createState() => _AddItemViewState();
}

class _AddItemViewState extends State<AddItemView> {
  Item item = Item(Uuid().v4(), "", 0, 0, DateTime.now(), null);

  @override
  Widget build(BuildContext context) {
    var positionsItems = itemPositions
        .map((pos) => DropdownMenuItem<int>(
            value: pos,
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.2),
                          blurRadius: 0.2)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 25.0),
                  child: Text(
                    pos.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ),
              ),
            )))
        .toList();

    return AlertDialog(
      shape: const RoundedRectangleBorder(),
      title: Column(
        children: const [
          Center(child: Text("Ajouter un aliment")),
          SizedBox(height: 12.0),
          Divider(
            color: Colors.deepPurple,
            height: 4.0,
            thickness: 2.0,
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
                decoration: const InputDecoration(labelText: "Libellé"),
                onChanged: (value) => setState(() => item.label = value)),
            TextFormField(
              decoration: const InputDecoration(labelText: "Quantité"),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  setState(() => item.quantity = int.parse(value)),
            ),
            DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: "Position"),
                isExpanded: false,
                selectedItemBuilder: (ctx) =>
                    itemPositions.map((e) => Text(e.toString())).toList(),
                items: positionsItems,
                onChanged: (value) => setState(() => item.position = value!)),
            DropdownButtonFormField<Category>(
                decoration: const InputDecoration(labelText: "Catégorie"),
                isExpanded: false,
                items: Category.values
                    .map((cat) => DropdownMenuItem<Category>(
                        value: cat, child: Text(cat.label())))
                    .toList(),
                onChanged: (value) => setState(() => item.category = value)),
            TextFormField(
              decoration: const InputDecoration(labelText: "Autre info"),
              onChanged: (value) => setState(() => item.info = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Annuler",
              style: TextStyle(color: Colors.grey),
            )),
        ElevatedButton(
            onPressed: valid()
                ? () {
                    Navigator.pop(context, item);
                  }
                : null,
            child: const Text("Sauvegarder"))
      ],
    );
  }

  bool valid() {
    return item.label != "" &&
        item.position > 0 &&
        item.quantity > 0 &&
        item.category != null;
  }
}
