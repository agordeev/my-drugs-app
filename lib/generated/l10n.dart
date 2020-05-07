// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get appTitle {
    return Intl.message(
      'My Drugs',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  String get expiryDateFormat {
    return Intl.message(
      'MM/yyyy',
      name: 'expiryDateFormat',
      desc: '',
      args: [],
    );
  }

  String get buttonEdit {
    return Intl.message(
      'Edit',
      name: 'buttonEdit',
      desc: '',
      args: [],
    );
  }

  String get buttonDelete {
    return Intl.message(
      'Delete',
      name: 'buttonDelete',
      desc: '',
      args: [],
    );
  }

  String get validationEmptyRequiredField {
    return Intl.message(
      'Please fill this field',
      name: 'validationEmptyRequiredField',
      desc: '',
      args: [],
    );
  }

  String get validationInvalidExpiryDate {
    return Intl.message(
      'Please enter a valid expiry date',
      name: 'validationInvalidExpiryDate',
      desc: '',
      args: [],
    );
  }

  String get unknownRouteMessage {
    return Intl.message(
      'We\'re sorry, but there was an error in navigation.\nPlease try again or contact us.',
      name: 'unknownRouteMessage',
      desc: '',
      args: [],
    );
  }

  String drugListTotalItems(num itemsCount) {
    return Intl.plural(
      itemsCount,
      zero: 'No items',
      one: '1 item',
      other: '$itemsCount items',
      name: 'drugListTotalItems',
      desc: '',
      args: [itemsCount],
    );
  }

  String drugListTotalItemsSelected(num itemsCount) {
    return Intl.plural(
      itemsCount,
      zero: 'No items selected',
      one: '1 item selected',
      other: '$itemsCount items selected',
      name: 'drugListTotalItemsSelected',
      desc: '',
      args: [itemsCount],
    );
  }

  String get drugListNoItems {
    return Intl.message(
      'No drugs added yet',
      name: 'drugListNoItems',
      desc: '',
      args: [],
    );
  }

  String get drugListExpiredGroupTitle {
    return Intl.message(
      'Expired',
      name: 'drugListExpiredGroupTitle',
      desc: '',
      args: [],
    );
  }

  String get drugListNotExpiredGroupTitle {
    return Intl.message(
      'Not Expired',
      name: 'drugListNotExpiredGroupTitle',
      desc: '',
      args: [],
    );
  }

  String get drugListExpiresOnLabel {
    return Intl.message(
      'Expires On',
      name: 'drugListExpiresOnLabel',
      desc: '',
      args: [],
    );
  }

  String get manageDrugAddDrugModeTitle {
    return Intl.message(
      'Add Drug',
      name: 'manageDrugAddDrugModeTitle',
      desc: '',
      args: [],
    );
  }

  String get manageDrugAddDrugModeActionButtonTitle {
    return Intl.message(
      'Add',
      name: 'manageDrugAddDrugModeActionButtonTitle',
      desc: '',
      args: [],
    );
  }

  String get manageDrugEditDrugModeTitle {
    return Intl.message(
      'Edit Drug',
      name: 'manageDrugEditDrugModeTitle',
      desc: '',
      args: [],
    );
  }

  String get manageDrugEditDrugModeActionButtonTitle {
    return Intl.message(
      'Save',
      name: 'manageDrugEditDrugModeActionButtonTitle',
      desc: '',
      args: [],
    );
  }

  String get manageDrugNameFieldLabel {
    return Intl.message(
      'Name',
      name: 'manageDrugNameFieldLabel',
      desc: '',
      args: [],
    );
  }

  String get manageDrugNameFieldHint {
    return Intl.message(
      'Aspirin',
      name: 'manageDrugNameFieldHint',
      desc: '',
      args: [],
    );
  }

  String get manageDrugExpiresOnFieldLabel {
    return Intl.message(
      'Expires On',
      name: 'manageDrugExpiresOnFieldLabel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}