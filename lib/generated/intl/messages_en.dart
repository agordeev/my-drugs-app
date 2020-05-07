// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(itemsCount) => "${Intl.plural(itemsCount, zero: 'No items', one: '1 item', other: '${itemsCount} items')}";

  static m1(itemsCount) => "${Intl.plural(itemsCount, zero: 'No items selected', one: '1 item selected', other: '${itemsCount} items selected')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appTitle" : MessageLookupByLibrary.simpleMessage("My Drugs"),
    "buttonDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "buttonEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "drugListExpiredGroupTitle" : MessageLookupByLibrary.simpleMessage("Expired"),
    "drugListExpiresOnLabel" : MessageLookupByLibrary.simpleMessage("Expires On"),
    "drugListNoItems" : MessageLookupByLibrary.simpleMessage("No drugs added yet"),
    "drugListNotExpiredGroupTitle" : MessageLookupByLibrary.simpleMessage("Not Expired"),
    "drugListTotalItems" : m0,
    "drugListTotalItemsSelected" : m1,
    "expiryDateFormat" : MessageLookupByLibrary.simpleMessage("MM/yyyy"),
    "manageDrugAddDrugModeActionButtonTitle" : MessageLookupByLibrary.simpleMessage("Add"),
    "manageDrugAddDrugModeTitle" : MessageLookupByLibrary.simpleMessage("Add Drug"),
    "manageDrugEditDrugModeActionButtonTitle" : MessageLookupByLibrary.simpleMessage("Save"),
    "manageDrugEditDrugModeTitle" : MessageLookupByLibrary.simpleMessage("Edit Drug"),
    "manageDrugExpiresOnFieldLabel" : MessageLookupByLibrary.simpleMessage("Expires On"),
    "manageDrugNameFieldHint" : MessageLookupByLibrary.simpleMessage("Aspirin"),
    "manageDrugNameFieldLabel" : MessageLookupByLibrary.simpleMessage("Name"),
    "unknownRouteMessage" : MessageLookupByLibrary.simpleMessage("We\'re sorry, but there was an error in navigation.\nPlease try again or contact us."),
    "validationEmptyRequiredField" : MessageLookupByLibrary.simpleMessage("Please fill this field"),
    "validationInvalidExpiryDate" : MessageLookupByLibrary.simpleMessage("Please enter a valid expiry date")
  };
}
