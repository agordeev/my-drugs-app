import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:my_drugs/app/features/manage_drug/bloc/manage_drug_bloc.dart';
import 'package:my_drugs/app/misc/validators/validators.dart';
import 'package:my_drugs/app/widgets/app_card.dart';

class ManageDrugScreen extends StatelessWidget {
  final String title;
  final String actionButtonTitle;

  const ManageDrugScreen(
      {Key key, @required this.title, @required this.actionButtonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading:
            Theme.of(context).platform == TargetPlatform.android,
        actions: Theme.of(context).platform == TargetPlatform.android
            ? null
            : <Widget>[
                PlatformButton(
                  androidFlat: (context) => MaterialFlatButtonData(),
                  child: Icon(Icons.clear),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
      ),
      body: SafeArea(
        child: BlocBuilder<ManageDrugBloc, ManageDrugState>(
            builder: (context, state) {
          if (state is ManageDrugInitial) {
            return _buildContent(
              context,
              state,
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ManageDrugInitial state,
  ) {
    final labelTextStyle = Theme.of(context).textTheme.subtitle2.copyWith(
          color: Theme.of(context).hintColor,
        );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: state.formKey,
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
                    TextFormField(
                      controller: state.nameController,
                      decoration: InputDecoration(
                        hintText: 'Aspirin',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) =>
                          RequiredFieldValidator.validate(context, value),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'EXPIRES ON:',
                      style: labelTextStyle,
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: state.expiresOnController,
                      decoration: InputDecoration(
                        hintText: state.expiresOnPlaceholderText,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '##/####',
                          filter: {
                            '#': RegExp(r'[0-9]'),
                          },
                        ),
                      ],
                      validator: (value) =>
                          ExpiresOnFieldValidator.validate(context, value),
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
                  actionButtonTitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
                onPressed: () => BlocProvider.of<ManageDrugBloc>(context)
                    .add(ManageDrugDrugStored()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
