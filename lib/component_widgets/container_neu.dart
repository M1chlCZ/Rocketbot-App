import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeuContainer extends StatelessWidget {
  final Widget? child;
  const NeuContainer({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        boxShadow: const [
          BoxShadow(
            offset: Offset(-1,-1),
            blurRadius: 4.0,
            color: Color.fromRGBO(134, 134, 134, 0.15),
          ),
          BoxShadow(
            offset: Offset(1,1),
            blurRadius: 4.0,
            color: Color.fromRGBO(2, 2, 2, 0.85),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: child,
      ),
    );
  }
}
