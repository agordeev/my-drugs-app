import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:my_drugs/app/widgets/app_card.dart';

class ManageDrugScreen extends StatelessWidget {
  final _dateFormat = DateFormat('MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Drug'),
      ),
      body: SafeArea(
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final labelTextStyle = Theme.of(context).textTheme.subtitle2.copyWith(
          color: Theme.of(context).hintColor,
        );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Expanded(
              child: AppCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'NAME:',
                    style: labelTextStyle,
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      hintText: 'Aspirin',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'EXPIRES ON:',
                    style: labelTextStyle,
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(
                        12.0,
                      ),
                      hintText: _dateFormat.format(DateTime.utc(2020, 5, 30)),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##/####',
                        filter: {
                          '#': RegExp(r'[0-9]'),
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
          SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: PlatformButton(
              android: (context) => MaterialRaisedButtonData(
                color: Theme.of(context).colorScheme.primary,
              ),
              ios: (context) => CupertinoButtonData(
                  color: Theme.of(context).colorScheme.primary),
              child: Text(
                'ADD',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
