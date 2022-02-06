import 'package:flutter/material.dart';

class FlatCustomButton extends StatelessWidget {
  final double radius;
  final Color? color;
  final Color? borderColor;
  final VoidCallback?  onTap;
  final Icon? icon;
  final AnimatedIcon? animIcon;
  final Color? splashColor;
  final Image? imageIcon;
  final Widget? child;

  const FlatCustomButton({Key? key, this.color, this.onTap, this.icon, this.imageIcon, this.splashColor, this.animIcon, this.radius = 4.0, this.child, this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: borderColor != null ? Border.all(color: borderColor!, width: 1.5) : null,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Material(
          color: color, // button color
          child: InkWell(
            // highlightColor: splashColor!.withOpacity(0.5),
            splashColor: splashColor ?? Colors.white30,
            highlightColor: splashColor ?? Colors.white30,// splash color
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
