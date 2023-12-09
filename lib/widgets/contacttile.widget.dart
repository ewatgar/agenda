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
    ThemeData theme = Theme.of(context);
    AgendaData agenda = Provider.of<AgendaData>(context);

    return ListTile(
        onTap: () => _navigateToContactDetails(context, contact, agenda),
        leading: LabelIcon(labels: contact.labels),
        title: Wrap(
          children: [
            Text("${contact.name} ${contact.surname}"),
            if (contact.isFavorite) Icon(Icons.star, size: 15)
          ],
        ),
        subtitle: Text(
            "${contact.email ?? ""}${contact.email != null && contact.phone != null ? ", " : ""}${contact.phone ?? ""}"),
        trailing: PopupMenuButton<int>(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onSelected: (int value) {
            if (value == 1) {
              _navigateToContactDetails(context, contact, agenda);
            } else if (value == 2) {
              print("Editar ${contact.name}");
            } else if (value == 3) {
              _showDialogDeleteContact(context, theme, agenda);
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

  Future<dynamic> _showDialogDeleteContact(
      BuildContext context, ThemeData theme, AgendaData agenda) {
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

  Future<void> _navigateToContactDetails(
      BuildContext context, ContactData contact, AgendaData agenda) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ContactDetailsPage(contact: contact)));
    agenda.notifyChanges();
  }
}
