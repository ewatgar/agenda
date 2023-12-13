// ignore_for_file: prefer_const_constructors

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:agenda/models/funciones.dart';
import 'package:agenda/widgets/labelicon.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
  });

  final ContactData contact;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AgendaData agenda = Provider.of<AgendaData>(context);

    return ListTile(
        onTap: () => navigateToContactDetails(context, contact, agenda),
        leading: LabelIcon(labels: contact.labels),
        title: Wrap(
          children: [
            Text("${contact.name ?? ''} ${contact.surname ?? ''}"),
            if (contact.isFavorite) Icon(Icons.star, size: 15)
          ],
        ),
        subtitle: Text(
            "${contact.email ?? ""}${contact.email != null && contact.phone != null ? ", " : ""}${contact.phone ?? ""}"),
        trailing: PopupMenuButton<int>(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onSelected: (int value) {
            if (value == 1) {
              navigateToContactDetails(context, contact, agenda);
            } else if (value == 2) {
              navigateToContactEdit(context, contact, agenda);
            } else if (value == 3) {
              showDialogDeleteContact(context, theme, agenda, contact);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 1,
                child: ListTile(
                    leading: Icon(Icons.remove_red_eye), title: Text("Ver"))),
            PopupMenuItem(
                value: 2,
                child:
                    ListTile(leading: Icon(Icons.edit), title: Text("Editar"))),
            PopupMenuItem(
                value: 3,
                child: ListTile(
                    iconColor: Colors.redAccent[100],
                    textColor: Colors.redAccent[100],
                    leading: Icon(Icons.delete),
                    title: Text("Eliminar")))
          ],
        ));
  }
}
