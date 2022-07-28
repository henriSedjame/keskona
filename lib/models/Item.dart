
import 'package:flutter/foundation.dart';

class Item {
   late String id;
   late String label;
   late int quantity;
   late int position;
   late DateTime date;
   late Category? category;
   late String? info;

   Item(this.id, this.label, this.quantity, this.position, this.date, this.category, {this.info});

   factory Item.fromJson(Map<String, dynamic> json) {
      return Item(
          json["id"], json["label"], json["quantity"], json["position"], json["date"], Category.from(json["category"]), info: json["info"]);
   }

   String congelationDate() {
     return "${format(date.day)}/${format(date.month)}/${format(date.year)}";
   }

   String format(int n) {
     if(n.toString().length == 1) {
       return "0$n";
     }
     return n.toString();
   }
}

enum Category {
   platsCuisines,
   viandesPoissons,
   fruitsLegumes,
   painsViennoiseries,
   autres;

   factory Category.from(String name) {
      return Category.values.where((e) => e.name == name).first;
   }
   String label() {
      switch(this) {
        case Category.platsCuisines:
          return "🥘 Plats cuisinés";
        case Category.viandesPoissons:
          return "🥩 Viandes ou Poissons";
        case Category.fruitsLegumes:
          return "🥦 Fruits ou légumes";
        case Category.painsViennoiseries:
          return "🥖 Pains ou viennoiseries";
        case Category.autres:
            return "🍳 Autres...";
      }
   }

   String icon() {
      switch(this) {
         case Category.platsCuisines:
            return "🥘";
         case Category.viandesPoissons:
            return "🥩";
         case Category.fruitsLegumes:
            return "🥦";
         case Category.painsViennoiseries:
            return "🥖";

         case Category.autres:
            return "🍳";

      }
   }
}