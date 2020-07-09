import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_drugs/app/misc/extensions.dart';
import 'package:my_drugs/generated/l10n.dart';
import 'package:my_drugs/shared/constants.dart';

const kCupertinoSearchBarHeigth = 54.0;

class CustomCupertinoSearchBar extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(
        kCupertinoSearchBarHeigth,
      );

  final void Function(String) onSearchTextFieldUpdated;

  const CustomCupertinoSearchBar({
    Key key,
    @required this.onSearchTextFieldUpdated,
  }) : super(key: key);

  @override
  _CustomCupertinoSearchBarState createState() =>
      _CustomCupertinoSearchBarState();
}

class _CustomCupertinoSearchBarState extends State<CustomCupertinoSearchBar> {
  final _searchTextFieldFocusNode = FocusNode();
  final _searchTextController = TextEditingController();

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
    final color = const Color(0xFF3C3C43).withOpacity(0.6);
    return SizedBox(
      height: widget.preferredSize.height,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).isTablet() ? 16.0 : 160.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            bottom: kDefaultCupertinoBorderSide,
          ),
        ),
        child: TextField(
          controller: _searchTextController,
          textAlignVertical: TextAlignVertical.center,
          onChanged: widget.onSearchTextFieldUpdated,
          focusNode: _searchTextFieldFocusNode,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF767680).withOpacity(0.12),
            contentPadding: EdgeInsets.zero,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 36, maxHeight: 20),
            prefixIcon: Icon(
              CupertinoIcons.search,
              size: 20.0,
              color: color,
            ),
            hintText: S.of(context).searchHint,
            hintStyle: TextStyle(
              fontSize: 16,
              color: color,
            ),
            border: border,
            focusedBorder: border,
            enabledBorder: border,
            errorBorder: border,
            disabledBorder: border,
            suffixIcon: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                _searchTextController.text = '';
                widget.onSearchTextFieldUpdated(_searchTextController.text);

                // Unfocus all focus nodes
                _searchTextFieldFocusNode.unfocus();

                // Disable text field's focus node request
                _searchTextFieldFocusNode.canRequestFocus = false;

                //Enable the text field's focus node request after some delay
                Future.delayed(const Duration(milliseconds: 100), () {
                  _searchTextFieldFocusNode.canRequestFocus = true;
                });
              },
              child: Icon(
                CupertinoIcons.clear_circled_solid,
                size: 16,
                color: const Color(0xFF8E8E93),
              ),
            ),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 36, maxHeight: 20),
          ),
        ),
      ),
    );
  }
}
