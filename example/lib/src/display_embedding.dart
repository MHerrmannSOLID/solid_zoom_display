import 'package:flutter/material.dart';

class DisplayEmbedding extends StatelessWidget {
  final Widget child;

  const DisplayEmbedding({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: SizedBox(
          width: constraints.maxWidth * 0.75,
          height: constraints.maxHeight * 0.80,
          child: Column(
            children: [
              Text('This is a zoom display example',
                  style: TextStyle(fontSize: constraints.maxHeight * 0.03)),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1)),
                child: SizedBox(
                  width: constraints.maxWidth * 0.75,
                  height: constraints.maxHeight * 0.75,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
