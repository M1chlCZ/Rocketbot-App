import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeuButton extends StatelessWidget {
  final double radius;
  final Color? color;
  final VoidCallback?  onTap;
  final Icon? icon;
  final AnimatedIcon? animIcon;
  final Color? splashColor;
  final Image? imageIcon;
  final Widget? child;

  NeuButton({Key? key, this.color, this.onTap, this.icon, this.imageIcon, this.splashColor, this.animIcon, this.radius = 4.0, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        boxShadow: [
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
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Material(
          color: Theme.of(context).canvasColor, // button color
          child: InkWell(
            // highlightColor: splashColor!.withOpacity(0.5),
            splashColor: splashColor ?? Colors.white70, // splash color
            onTap: onTap, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                animIcon ?? Container(),
                icon ?? Container(),
                imageIcon ?? Container(),
                child ?? Container(), // icon
              ],
            ),
          ),
        ),
      ),
    );
  }
}
