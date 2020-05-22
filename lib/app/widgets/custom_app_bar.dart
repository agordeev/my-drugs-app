import 'package:flutter/material.dart';

import 'custom_cupertino_search_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final void Function(String) onSearchTextFieldUpdated;

  final _searchTextController = TextEditingController();

  @override
  final Size preferredSize;

  CustomAppBar({
    Key key,
    @required this.title,
    this.actions,
    this.onSearchTextFieldUpdated,
    @required TargetPlatform platform,
  })  : preferredSize = Size.fromHeight(
          kToolbarHeight +
              (platform == TargetPlatform.iOS ? kCupertinoSearchBarHeigth : 0),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget bottom;
    double elevation;
    var actions = this.actions;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      bottom = CustomCupertinoSearchBar(
        controller: _searchTextController,
        onChanged: onSearchTextFieldUpdated,
      );
      elevation = 0;
    } else {
      actions = <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ] +
          actions;
    }
    return AppBar(
      title: Text(title),
      actions: actions,
      elevation: elevation,
      bottom: bottom,
    );
  }
}
