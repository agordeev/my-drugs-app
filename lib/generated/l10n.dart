// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My Drugs`
  String get appTitle {
    return Intl.message(
      'My Drugs',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `MM/yyyy`
  String get expiryDateFormat {
    return Intl.message(
      'MM/yyyy',
      name: 'expiryDateFormat',
      desc: '',
      args: [],
    );
  }

  /// `/`
  String get dateDelimeter {
    return Intl.message(
      '/',
      name: 'dateDelimeter',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get buttonEdit {
    return Intl.message(
      'Edit',
      name: 'buttonEdit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get buttonDelete {
    return Intl.message(
      'Delete',
      name: 'buttonDelete',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get searchHint {
    return Intl.message(
      'Search',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Please fill this field`
  String get validationEmptyRequiredField {
    return Intl.message(
      'Please fill this field',
      name: 'validationEmptyRequiredField',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid expiry date`
  String get validationInvalidExpiryDate {
    return Intl.message(
      'Please enter a valid expiry date',
      name: 'validationInvalidExpiryDate',
      desc: '',
      args: [],
    );
  }

  /// `We're sorry, but there was an error in navigation.\nPlease try again or contact us.`
  String get unknownRouteMessage {
    return Intl.message(
      'We\'re sorry, but there was an error in navigation.\nPlease try again or contact us.',
      name: 'unknownRouteMessage',
      desc: '',
      args: [],
    );
  }

  /// `{itemsCount, plural, zero{No items} one{1 item} other{{itemsCount} items}}`
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

  /// `{itemsCount, plural, zero{No items selected} one{1 item selected} other{{itemsCount} items selected}}`
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

  /// `No drugs added yet`
  String get drugListNoItems {
    return Intl.message(
      'No drugs added yet',
      name: 'drugListNoItems',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get drugListExpiredGroupTitle {
    return Intl.message(
      'Expired',
      name: 'drugListExpiredGroupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Not Expired`
  String get drugListNotExpiredGroupTitle {
    return Intl.message(
      'Not Expired',
      name: 'drugListNotExpiredGroupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Expires On`
  String get drugListExpiresOnLabel {
    return Intl.message(
      'Expires On',
      name: 'drugListExpiresOnLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add Drug`
  String get manageDrugAddDrugModeTitle {
    return Intl.message(
      'Add Drug',
      name: 'manageDrugAddDrugModeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get manageDrugAddDrugModeActionButtonTitle {
    return Intl.message(
      'Add',
      name: 'manageDrugAddDrugModeActionButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Drug`
  String get manageDrugEditDrugModeTitle {
    return Intl.message(
      'Edit Drug',
      name: 'manageDrugEditDrugModeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get manageDrugEditDrugModeActionButtonTitle {
    return Intl.message(
      'Save',
      name: 'manageDrugEditDrugModeActionButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get manageDrugNameFieldLabel {
    return Intl.message(
      'Name',
      name: 'manageDrugNameFieldLabel',
      desc: '',
      args: [],
    );
  }

  /// `Aspirin`
  String get manageDrugNameFieldHint {
    return Intl.message(
      'Aspirin',
      name: 'manageDrugNameFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `Expires On`
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
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}