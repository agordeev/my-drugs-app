import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:my_drugs/generated/l10n.dart';

/// A material [AppBar] with search functionality.
class CustomMaterialSearchAppBar extends StatefulWidget {
  final String title;
  final List<Widget> actions;
  final void Function(String) onSearchTextFieldUpdated;

  const CustomMaterialSearchAppBar({
    Key key,
    this.title,
    this.actions,
    @required this.onSearchTextFieldUpdated,
  }) : super(key: key);

  @override
  _CustomMaterialSearchAppBarState createState() =>
      _CustomMaterialSearchAppBarState();
}

class _CustomMaterialSearchAppBarState extends State<CustomMaterialSearchAppBar>
    with SingleTickerProviderStateMixin {
  final _searchTextFieldFocusNode = FocusNode();
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
    _searchTextFieldFocusNode.dispose();
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
    if (!isSearchTextFieldVisible && widget.actions != null) {
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
      _searchTextFieldFocusNode.requestFocus();
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
    widget.onSearchTextFieldUpdated(_searchTextController.text);
  }

  TextField _buildSearchTextField(BuildContext context) {
    return TextField(
      controller: _searchTextController,
      focusNode: _searchTextFieldFocusNode,
      onChanged: widget.onSearchTextFieldUpdated,
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
