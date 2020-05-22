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
  })  : preferredSize = Size.fromHeight(kToolbarHeight + 54.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      elevation: 0,
      bottom: CustomCupertinoSearchBar(
        controller: _searchTextController,
        onChanged: onSearchTextFieldUpdated,
      ),
    );
  }
}
