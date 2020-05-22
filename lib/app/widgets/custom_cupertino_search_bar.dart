import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_drugs/generated/l10n.dart';

class CustomCupertinoSearchBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const CustomCupertinoSearchBar({
    Key key,
    @required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Size get preferredSize => Size(
        double.infinity,
        54.0,
      );

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
    final color = Color(0xFF3C3C43).withOpacity(0.6);
    return Material(
      child: SizedBox(
        height: preferredSize.height,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          color: Colors.white,
          child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            onChanged: onChanged,
            // focusNode: textFieldFocusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF767680).withOpacity(0.12),
              contentPadding: EdgeInsets.zero,
              prefixIconConstraints:
                  BoxConstraints(minWidth: 36, maxHeight: 20),
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
                  controller.text = '';
                  onChanged(controller.text);

                  // // Unfocus all focus nodes
                  // textFieldFocusNode.unfocus();

                  // // Disable text field's focus node request
                  // textFieldFocusNode.canRequestFocus = false;

                  // //Enable the text field's focus node request after some delay
                  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  //   textFieldFocusNode.canRequestFocus = true;
                  // });
                },
                child: Icon(
                  CupertinoIcons.clear_circled_solid,
                  size: 16,
                  color: Color(0xFF8E8E93),
                ),
              ),
              suffixIconConstraints:
                  BoxConstraints(minWidth: 36, maxHeight: 20),
            ),
          ),
        ),
      ),
    );
  }
}
