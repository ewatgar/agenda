// ignore_for_file: prefer_const_constructors

import 'package:agenda/models/contact.data.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
  });

  final ContactData contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.ac_unit),
        title: Text("${contact.name} ${contact.surname}"),
        subtitle: Text(
            "${contact.email ?? ""}${contact.email != null && contact.phone != null ? ", " : ""}${contact.phone ?? ""}"),
        trailing: PopupMenuButton(
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
