import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:my_drugs/app/features/manage_drug/bloc/manage_drug_bloc.dart';
import 'package:my_drugs/app/misc/utils.dart';
import 'package:my_drugs/app/misc/validators/validators.dart';
import 'package:my_drugs/app/widgets/app_card.dart';
import 'package:my_drugs/generated/l10n.dart';

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
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(Icons.clear),
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
    return Padding(
      padding: EdgeInsets.all(
        isTablet() ? 32.0 : 16.0,
      ),
      child: Form(
        key: state.formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: AppCard(
                child: ScrollConfiguration(
                  behavior: _InvisibleScrollBehavior(),
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: <Widget>[
                      const SizedBox(height: 8.0),
                      TextFormField(
                        autofocus: true,
                        controller: state.nameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 16.0,
                          ),
                          labelText: S.of(context).manageDrugNameFieldLabel,
                          hintText: S.of(context).manageDrugNameFieldHint,
                          counterText: '',
                          alignLabelWithHint: true,
                        ),
                        maxLines: null,
                        maxLength: 200,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) =>
                            RequiredFieldValidator.validate(context, value),
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: state.expiresOnController,
                        decoration: InputDecoration(
                          labelText:
                              S.of(context).manageDrugExpiresOnFieldLabel,
                          hintText: state.expiresOnPlaceholderText,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: state.expiresOnMask,
                            filter: {
                              '#': RegExp('[0-9]'),
                            },
                          ),
                        ],
                        validator: (value) =>
                            ExpiresOnFieldValidator.validate(context, value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: isTablet() ? kElementMaxWidth : double.infinity,
              child: PlatformButton(
                android: (context) => MaterialRaisedButtonData(
                  color: Theme.of(context).colorScheme.primary,
                ),
                ios: (context) => CupertinoButtonData(
                    color: Theme.of(context).colorScheme.primary),
                onPressed: () => BlocProvider.of<ManageDrugBloc>(context)
                    .add(ManageDrugDrugStored()),
                child: Text(
                  actionButtonTitle.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hides scroll glow on Android and removes overscroll (bounce) effect on iOS.
/// That makes the scroll unnoticable to the user.
class _InvisibleScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();
}
