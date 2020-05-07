// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static m0(itemsCount) => "${Intl.plural(itemsCount, zero: 'Нет лекарств', one: '${itemsCount} лекарство', few: '${itemsCount} лекарства', many: '${itemsCount} лекарств', other: '${itemsCount} лекарств')}";

  static m1(itemsCount) => "${Intl.plural(itemsCount, zero: 'Выбрано 0 лекарств', one: 'Выбрано ${itemsCount} лекарство', few: 'Выбрано ${itemsCount} лекарства', many: 'Выбрано ${itemsCount} лекарств', other: 'Выбрано ${itemsCount} лекарств')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appTitle" : MessageLookupByLibrary.simpleMessage("Мои лекарства"),
    "buttonDelete" : MessageLookupByLibrary.simpleMessage("Удалить"),
    "buttonEdit" : MessageLookupByLibrary.simpleMessage("Изменить"),
    "drugListExpiredGroupTitle" : MessageLookupByLibrary.simpleMessage("Просроченные"),
    "drugListExpiresOnLabel" : MessageLookupByLibrary.simpleMessage("Годен до"),
    "drugListNoItems" : MessageLookupByLibrary.simpleMessage("Нет добавленных лекарств"),
    "drugListNotExpiredGroupTitle" : MessageLookupByLibrary.simpleMessage("Непросроченные"),
    "drugListTotalItems" : m0,
    "drugListTotalItemsSelected" : m1,
    "expiryDateFormat" : MessageLookupByLibrary.simpleMessage("MM.yyyy"),
    "manageDrugAddDrugModeActionButtonTitle" : MessageLookupByLibrary.simpleMessage("Добавить"),
    "manageDrugAddDrugModeTitle" : MessageLookupByLibrary.simpleMessage("Добавить лекарство"),
    "manageDrugEditDrugModeActionButtonTitle" : MessageLookupByLibrary.simpleMessage("Сохранить"),
    "manageDrugEditDrugModeTitle" : MessageLookupByLibrary.simpleMessage("Изменить лекарство"),
    "manageDrugExpiresOnFieldLabel" : MessageLookupByLibrary.simpleMessage("Годен до"),
    "manageDrugNameFieldHint" : MessageLookupByLibrary.simpleMessage("Аспирин"),
    "manageDrugNameFieldLabel" : MessageLookupByLibrary.simpleMessage("Наименование"),
    "validationEmptyRequiredField" : MessageLookupByLibrary.simpleMessage("Заполните это поле"),
    "validationInvalidExpiryDate" : MessageLookupByLibrary.simpleMessage("Введите верный срок годности")
  };
}
