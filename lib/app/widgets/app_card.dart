import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback onPressed;

  const AppCard({
    Key key,
    this.child,
    this.padding = const EdgeInsets.all(12.0),
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(
      Radius.circular(4.0),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey[400],
            blurRadius: 4.0,
          ),
        ],
      ),
      child: child,
    );
  }
}
