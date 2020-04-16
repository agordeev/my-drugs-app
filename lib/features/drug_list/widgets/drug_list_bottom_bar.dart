import 'package:flutter/material.dart';

class DrugListBottomBar extends StatelessWidget {
  final AnimationController animationController;
  final String numberOfItemsTotal;
  final String numberOfItemsSelected;
  final Animation<Offset> numberOfItemsTotalOffset;
  final Animation<double> numberOfItemsTotalOpacity;
  final Animation<Offset> numberOfItemsSelectedOffset;
  final Animation<double> numberOfItemsSelectedOpacity;

  DrugListBottomBar(
      {Key key,
      @required this.animationController,
      @required this.numberOfItemsTotal,
      @required this.numberOfItemsSelected})
      : numberOfItemsTotalOffset = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(0.0, 0.3),
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.0, 0.8, curve: Curves.ease),
          ),
        ),
        numberOfItemsTotalOpacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.0, 0.8, curve: Curves.ease),
          ),
        ),
        numberOfItemsSelectedOffset = Tween<Offset>(
          begin: Offset(0.0, -0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.2, 1.0, curve: Curves.ease),
          ),
        ),
        numberOfItemsSelectedOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.2, 1.0, curve: Curves.ease),
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Colors.grey[350],
            ),
          )),
      child: SafeArea(
        child: Container(
          height: 34,
          child: ClipRect(
            child: AnimatedBuilder(
                animation: animationController, builder: _buildContent),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Widget child) {
    return Stack(
      children: <Widget>[
        _buildRow(
          context,
          numberOfItemsTotalOpacity,
          numberOfItemsTotalOffset,
          numberOfItemsTotal,
          Icon(Icons.add),
          () {},
        ),
        _buildRow(
          context,
          numberOfItemsSelectedOpacity,
          numberOfItemsSelectedOffset,
          numberOfItemsSelected,
          Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
          () {},
        ),
      ],
    );
  }

  Widget _buildRow(
      BuildContext context,
      Animation<double> opacity,
      Animation<Offset> position,
      String text,
      Icon icon,
      VoidCallback onPressed) {
    return Center(
      child: Opacity(
        opacity: opacity.value,
        child: SlideTransition(
          position: position,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Spacer(),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    child: IconButton(
                      icon: icon,
                      onPressed: onPressed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
