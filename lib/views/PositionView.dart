import 'package:flutter/material.dart';
import 'package:keskona/models/constants.dart';

class PositionView extends StatelessWidget {
  final int pos;

  const PositionView({Key? key, required this.pos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(1.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: itemPositions
              .map((e) => Container(
                    width: 60.0,
                    height: 25.0,
                    decoration: BoxDecoration(
                        color: (pos == e) ? Colors.deepPurple : Colors.white,
                        border: Border.all(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(2.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.2),
                            blurRadius: 0.5
                          )
                        ]
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
