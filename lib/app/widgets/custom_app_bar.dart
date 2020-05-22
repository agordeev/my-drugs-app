import 'package:flutter/material.dart';
import 'package:my_drugs/app/widgets/custom_material_search_app_bar.dart';

import 'custom_cupertino_search_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final void Function(String) onSearchTextFieldUpdated;

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
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return AppBar(
        title: Text(title),
        actions: actions,
        elevation: 0,
        bottom: CustomCupertinoSearchBar(
          onSearchTextFieldUpdated: onSearchTextFieldUpdated,
        ),
      );
    } else {
      return CustomMaterialSearchAppBar(
        title: title,
        actions: actions,
        onSearchTextFieldUpdated: onSearchTextFieldUpdated,
      );
    }
  }
}
