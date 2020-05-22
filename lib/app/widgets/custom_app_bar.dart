import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:my_drugs/generated/l10n.dart';

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
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return AppBar(
        title: Text(title),
        actions: actions,
        elevation: 0,
        bottom: CustomCupertinoSearchBar(
          controller: _searchTextController,
          onChanged: onSearchTextFieldUpdated,
        ),
      );
    } else {
      return CustomMaterialAppBar(
        title: title,
        actions: actions,
      );
    }
  }
}

/// TODO: Move to separate file.
/// A material [AppBar] with search functionality.
class CustomMaterialAppBar extends StatefulWidget {
  final String title;
  final List<Widget> actions;
  final void Function(String) onSearchTextFieldUpdated;

  CustomMaterialAppBar(
      {Key key, this.title, this.actions, this.onSearchTextFieldUpdated})
      : super(key: key);

  @override
  _CustomMaterialAppBarState createState() => _CustomMaterialAppBarState();
}

class _CustomMaterialAppBarState extends State<CustomMaterialAppBar>
    with SingleTickerProviderStateMixin {
  final _searchTextController = TextEditingController();
  bool isSearchTextFieldVisible = false;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_onPhysicalBackButtonPress);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_onPhysicalBackButtonPress);
    _searchTextController.dispose();
    super.dispose();
  }

  /// Called when Android's physical Back button pressed. Hide the search text field.
  bool _onPhysicalBackButtonPress(bool stopDefaultButtonEvent) {
    if (isSearchTextFieldVisible) {
      _hideSearchTextField();
      return true;
    }
    return stopDefaultButtonEvent;
  }

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[
      IconButton(
        icon: Icon(isSearchTextFieldVisible ? Icons.close : Icons.search),
        onPressed: isSearchTextFieldVisible
            ? _clearSearchTextField
            : _showSearchTextField,
      )
    ];
    if (!isSearchTextFieldVisible) {
      actions.addAll(widget.actions);
    }
    return AppBar(
      leading: isSearchTextFieldVisible
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _hideSearchTextField,
            )
          : null,
      title: isSearchTextFieldVisible
          ? _buildSearchTextField(context)
          : Text(widget.title),
      actions: actions,
    );
  }

  void _showSearchTextField() {
    setState(() {
      isSearchTextFieldVisible = true;
    });
  }

  void _hideSearchTextField() {
    _clearSearchTextField();
    setState(() {
      isSearchTextFieldVisible = false;
    });
  }

  void _clearSearchTextField() {
    _searchTextController.text = '';
  }

  TextField _buildSearchTextField(BuildContext context) {
    return TextField(
      controller: _searchTextController,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: S.of(context).searchHint,
      ),
      textInputAction: TextInputAction.search,
    );
  }
}
