// ignore_for_file: prefer_const_constructors

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:agenda/pages/contactdetails.page.dart';
import 'package:agenda/pages/contactedit.page.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

int diacriticsCaseAwareCompareTo(String a, String b) {
  String aFormat = removeDiacritics(a.toUpperCase());
  String bFormat = removeDiacritics(b.toUpperCase());
  return aFormat.compareTo(bFormat);
}

Future<void> navigateToContactDetails(
    BuildContext context, ContactData contact, AgendaData agenda) async {
  await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ContactDetailsPage(contact: contact)));
  agenda.notifyChanges();
}

Future<void> navigateToContactEdit(
    BuildContext context, ContactData contact, AgendaData agenda) async {
  await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ContactEditPage(contact: contact)));
  agenda.notifyChanges();
}

Future<void> navigateToContactCreation(
    BuildContext context, AgendaData agenda) async {
  ContactData newContact = ContactData();
  bool reply = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ContactEditPage(contact: newContact, isNew: true)));
  if (reply) {
    agenda.contacts.add(newContact);
    agenda.notifyChanges();
  }
}

Future<dynamic> showDialogDeleteContact(BuildContext context, ThemeData theme,
    AgendaData agenda, ContactData contact) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Atención",
        style: theme.textTheme.headlineSmall,
      ),
      content: Text("Estás a punto de borrar un contacto, ¿Estás seguro?"),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
            onPressed: () {
              agenda.dropContact(id: contact.id);
              agenda.notifyChanges();
              Navigator.of(context).pop();
            },
            child: Text("Aceptar")),
        OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"))
      ],
    ),
  );
}

Future<bool?> leavePageSave(BuildContext context, ContactData contact,
    ContactData copy, bool modified) async {
  if (modified) {
    contact.isFavorite = copy.isFavorite;
    contact.labels = copy.labels;
    contact.modification = DateTime.now();
    Navigator.of(context).pop(true);
    return true;
  }
  Navigator.of(context).pop(false);
  return false;
}

Future<bool?> leavePageAsk(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
        title: Text("Atención"),
        content: Text("¿Seguro que deseas salir? Los cambios no se guardarán"),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
              },
              child: Text("Sí")),
          OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("No")),
        ]),
  );
}
