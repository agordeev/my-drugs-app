import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DrugListBottomBar extends StatefulWidget {
  final AnimationController screenModeAnimationController;
  final String numberOfItemsTotal;
  final String numberOfItemsSelected;
  final bool isDeleteButtonActive;
  final Animation<Offset> numberOfItemsTotalOffset;
  final Animation<double> numberOfItemsTotalOpacity;
  final Animation<Offset> numberOfItemsSelectedOffset;
  final Animation<double> numberOfItemsSelectedOpacity;

  DrugListBottomBar({
    Key key,
    @required this.screenModeAnimationController,
    @required this.numberOfItemsTotal,
    @required this.numberOfItemsSelected,
    @required this.isDeleteButtonActive,
  })  : numberOfItemsTotalOffset = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(0.0, 0.3),
        ).animate(
          CurvedAnimation(
            parent: screenModeAnimationController,
            curve: Interval(0.0, 0.8, curve: Curves.ease),
          ),
        ),
        numberOfItemsTotalOpacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: screenModeAnimationController,
            curve: Interval(0.0, 0.8, curve: Curves.ease),
          ),
        ),
        numberOfItemsSelectedOffset = Tween<Offset>(
          begin: Offset(0.0, -0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: screenModeAnimationController,
            curve: Interval(0.2, 1.0, curve: Curves.ease),
          ),
        ),
        numberOfItemsSelectedOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: screenModeAnimationController,
            curve: Interval(0.2, 1.0, curve: Curves.ease),
          ),
        ),
        super(key: key);

  @override
  DrugListBottomBarState createState() => DrugListBottomBarState();
}

class DrugListBottomBarState extends State<DrugListBottomBar>
    with SingleTickerProviderStateMixin {
  AnimationController deleteButtonColorAnimationController;
  Animation<Color> _colorAnimation;
  final double _height = 44;

  @override
  void initState() {
    deleteButtonColorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.red[500],
    ).animate(
      deleteButtonColorAnimationController,
    );
    super.initState();
  }

  @override
  void dispose() {
    deleteButtonColorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Colors.grey[350],
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 34,
          child: ClipRect(
            child: AnimatedBuilder(
              animation: widget.screenModeAnimationController,
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
        AnimatedBuilder(
          animation: _colorAnimation,
          builder: (BuildContext context, Widget child) => _buildRow(
            context,
            widget.screenModeAnimationController.status ==
                AnimationStatus.dismissed,
            widget.numberOfItemsSelectedOpacity,
            widget.numberOfItemsSelectedOffset,
            widget.numberOfItemsSelected,
            Icon(
              Icons.delete,
              color: _colorAnimation.value,
            ),
            _colorAnimation.value,
            widget.isDeleteButtonActive
                ? () {
                    print('Delete');
                  }
                : null,
          ),
        ),
        _buildRow(
          context,
          widget.screenModeAnimationController.status ==
              AnimationStatus.completed,
          widget.numberOfItemsTotalOpacity,
          widget.numberOfItemsTotalOffset,
          widget.numberOfItemsTotal,
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
    Widget icon,
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
                      width: _height,
                      height: _height,
                      child: PlatformButton(
                        androidFlat: (context) => MaterialFlatButtonData(),
                        padding: const EdgeInsets.all(0.0),
                        // color: color,
                        // disabledColor: color,
                        child: icon,
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
