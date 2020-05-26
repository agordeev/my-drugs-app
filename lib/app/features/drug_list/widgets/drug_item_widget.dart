import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/app/features/drug_list/bloc/drug_list_bloc.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_item.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_list_row.dart';
import 'package:my_drugs/generated/l10n.dart';

class DrugItemWidget extends DrugListRow {
  final DrugListRowItem item;

  /// A padding of parent widget. 16 by default.
  final double horizontalPadding = 16;

  DrugItemWidget({
    Key key,
    @required this.item,
    @required bool isSelected,
    @required Animation<double> editModeAnimation,
  }) : super(
          key: key,
          isSelected: isSelected,
          editModeAnimation: editModeAnimation,
        );

  @override
  DrugListRowState createState() => DrugItemRowState();
}

class DrugItemRowState extends DrugListRowState<DrugItemWidget> {
  final double _expiresOnWidth = 90;
  final double _height = 68;
  final _backgroundColor = Colors.white;

  /// Drug name block.
  @override
  Widget buildDynamicContent(BuildContext context) {
    final widgetWidth =
        MediaQuery.of(context).size.width - widget.horizontalPadding * 2;
    final textWidth = widgetWidth - (_expiresOnWidth + 16 + 8);
    return Opacity(
      opacity: widget.item.isExpired ? 0.6 : 1.0,
      child: Container(
        height: _height,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: _backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0xFFD7D7D7),
            ),
          ],
        ),
        child: SizedBox(
          width: textWidth,
          child: Text(
            widget.item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildScaffold(BuildContext context, Widget animatedChild) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: animatedChild,
    );
  }

  /// EXPIRES ON block.
  @override
  Widget buildStaticContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 16,
          height: _height,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_backgroundColor.withOpacity(0), _backgroundColor],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          height: _height,
          width: _expiresOnWidth,
          color: _backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                S.of(context).drugListExpiresOnLabel.toUpperCase(),
                style: TextStyle(
                  color: Color(0xFFBABABA),
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                widget.item.formattedExpiresOn.replaceFirst(' ', '\n'),
                style: TextStyle(
                  color: Color(0xFF8C8C8C),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 8,
        ),
      ],
    );
  }

  @override
  void onTap() {
    final screenMode = BlocProvider.of<DrugListBloc>(context).currentScreenMode;
    if (screenMode == ScreenMode.edit) {
      _selectDeselect();
    } else {
      _presentBottomSheet(context);
    }
  }

  void _presentBottomSheet(
    BuildContext context,
  ) {
    final deleteButtonHandler = () => _onContextMenuDeletePressed(
          context,
        );
    final editButtonHandler = () {
      Navigator.of(context).pop();
      BlocProvider.of<DrugListBloc>(context)
          .add(DrugListEditingStarted(widget.item.id));
    };
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                S.of(context).buttonEdit,
              ),
              onPressed: editButtonHandler,
            ),
            CupertinoActionSheetAction(
              child: Text(
                S.of(context).buttonDelete,
              ),
              isDestructiveAction: true,
              onPressed: deleteButtonHandler,
            ),
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (_) => Wrap(
          children: <Widget>[
            SizedBox(height: 8),
            _buildBottomSheetRow(
              context,
              Icons.edit,
              S.of(context).buttonEdit,
              editButtonHandler,
            ),
            _buildBottomSheetRow(
              context,
              Icons.delete,
              S.of(context).buttonDelete,
              deleteButtonHandler,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBottomSheetRow(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(
                  icon,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(width: 8),
              Text(text),
            ],
          ),
        ),
      );

  void _onContextMenuDeletePressed(
    BuildContext context,
  ) {
    Navigator.of(context).pop();
    BlocProvider.of<DrugListBloc>(context).add(
      DrugListItemDeleted(
        widget.item.id,
      ),
    );
  }

  void _selectDeselect() {
    BlocProvider.of<DrugListBloc>(context).add(DrugListItemSelectionToggled(
      widget.item,
    ));
  }
}
