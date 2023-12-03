// ignore_for_file: prefer_const_constructors

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:agenda/pages/contactdetails.page.dart';
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
    AgendaData agenda = Provider.of<AgendaData>(context);

    return ListTile(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ContactDetailsPage()));
        },
        leading: LabelIcon(labels: contact.labels),
        title: Text("${contact.name} ${contact.surname}"),
        subtitle: Text(
            "${contact.email ?? ""}${contact.email != null && contact.phone != null ? ", " : ""}${contact.phone ?? ""}"),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 1) {
              /* */
            } else if (value == 2) {
            } else if (value == 3) {}
          },
          itemBuilder: ((context) => [
                PopupMenuItem(
                    child: ListTile(
                        leading: Icon(Icons.remove_red_eye),
                        title: Text("Ver"))),
                PopupMenuItem(
                    child: ListTile(
                        leading: Icon(Icons.edit), title: Text("Editar"))),
                PopupMenuItem(
                    child: ListTile(
                        leading: Icon(Icons.delete), title: Text("Eliminar")))
              ]),
        ));
  }
}
