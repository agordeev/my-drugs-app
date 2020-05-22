import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/app/features/drug_list/bloc/drug_list_bloc.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_item.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_item_group.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_list_row.dart';
import 'package:my_drugs/generated/l10n.dart';

class DrugItemWidget extends DrugListRow {
  final DrugItemGroup group;
  final DrugItem item;
  final bool isInEditMode;

  /// Animation comes from [AnimatedList].
  /// Used on removal.
  final Animation<double> animation;

  /// A padding of parent widget. 16 by default.
  final double horizontalPadding = 16;

  final VoidCallback onPresentContextMenuTap;

  DrugItemWidget({
    @required this.group,
    @required this.item,
    @required this.isInEditMode,
    @required this.onPresentContextMenuTap,
    @required this.animation,
    @required Animation<double> editModeAnimation,
  }) : super(
          key: item.key,
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
            widget.item.drug.name,
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
    return SizeTransition(
      sizeFactor: widget.animation,
      child: FadeTransition(
        opacity: widget.animation,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.isInEditMode
                ? () => BlocProvider.of<DrugListBloc>(context)
                        .add(SelectDeselectDrug(
                      widget.group,
                      widget.item,
                    ))
                : widget.onPresentContextMenuTap,
            child: animatedChild,
          ),
        ),
      ),
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
}
