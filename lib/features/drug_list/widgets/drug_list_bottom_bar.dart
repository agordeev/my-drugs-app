import 'package:flutter/material.dart';

class DrugListBottomBar extends StatelessWidget {
  final AnimationController animationController;
  final String numberOfItemsTotal;
  final String numberOfItemsSelected;
  final bool isDeleteButtonActive;
  final Animation<Offset> numberOfItemsTotalOffset;
  final Animation<double> numberOfItemsTotalOpacity;
  final Animation<Offset> numberOfItemsSelectedOffset;
  final Animation<double> numberOfItemsSelectedOpacity;

  final double height = 44;

  DrugListBottomBar({
    Key key,
    @required this.animationController,
    @required this.numberOfItemsTotal,
    @required this.numberOfItemsSelected,
    @required this.isDeleteButtonActive,
  })  : numberOfItemsTotalOffset = Tween<Offset>(
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
              animation: animationController,
              builder: _buildContent,
            ),
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
          animationController.status == AnimationStatus.dismissed,
          numberOfItemsSelectedOpacity,
          numberOfItemsSelectedOffset,
          numberOfItemsSelected,
          Icon(
            Icons.delete,
          ),
          Theme.of(context).colorScheme.error,
          isDeleteButtonActive
              ? () {
                  print('Delete');
                }
              : null,
        ),
        _buildRow(
          context,
          animationController.status == AnimationStatus.completed,
          numberOfItemsTotalOpacity,
          numberOfItemsTotalOffset,
          numberOfItemsTotal,
          Icon(Icons.add),
          null,
          () {
            print('Add');
          },
        ),
      ],
    );
  }

  Widget _buildRow(
    BuildContext context,
    bool ignoreTaps,
    Animation<double> opacity,
    Animation<Offset> position,
    String text,
    Icon icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return IgnorePointer(
      // Add and Delete buttons overlaps because we're offsetting them by 0.3, not 1.0 (see [numberOfItemsTotalOffset])
      // That causes the top button of the stack (Add button) to intercept touches even if it's not visible.
      // That's why we manually set whether a button should handle taps or not.
      ignoring: ignoreTaps,
      child: Center(
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
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      width: height,
                      height: height,
                      child: IconButton(
                        padding: const EdgeInsets.all(0.0),
                        color: color,
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
      ),
    );
  }
}
