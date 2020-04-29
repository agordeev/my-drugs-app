import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:my_drugs/app/widgets/app_card.dart';

class ManageDrugScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Drug'),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
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
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      labelText: 'Aspirin',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'EXPIRES ON:',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(
                        12.0,
                      ),
                      hintText: '01.2020',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
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
