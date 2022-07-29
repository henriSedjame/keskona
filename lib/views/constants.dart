import 'package:flutter/material.dart';
import 'package:keskona/models/constants.dart';

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