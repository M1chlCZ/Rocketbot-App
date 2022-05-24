import 'package:flutter/material.dart';

class NeuContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final double? radius;
  const NeuContainer({Key? key, this.child, this.height, this.width, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getContainer(height, width,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.all(Radius.circular(_getRadius())),
        boxShadow: const [
          BoxShadow(
            offset: Offset(-1,-1),
            blurRadius: 4.0,
            color: Color.fromRGBO(134, 134, 134, 0.05),
          ),
          BoxShadow(
            offset: Offset(1,1),
            blurRadius: 4.0,
            color: Color.fromRGBO(2, 2, 2, 0.45),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: child,
      ),
    );
  }

  double _getRadius() {
   return radius == null ? 4.0 : radius!;
  }

  Container _getContainer(double? height, double? width, {required BoxDecoration decoration, required Widget child}) {
    if(height != null) {
      assert (width !=null);
      return Container(height: height, width: width, decoration: decoration, child: child,);
    }else{
      return Container(decoration: decoration, child: child,);
    }
  }
}
