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
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ContactDetailsPage(contact: contact)));
        },
        leading: LabelIcon(labels: contact.labels),
        title: Text("${contact.name} ${contact.surname}"),
        subtitle: Text(
            "${contact.email ?? ""}${contact.email != null && contact.phone != null ? ", " : ""}${contact.phone ?? ""}"),
        trailing: PopupMenuButton<int>(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          //LOGICA AL CLICKEAR OPCION MENU CONTACTO
          onSelected: (int value) {
            if (value == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactDetailsPage(contact: contact)));
            } else if (value == 2) {
              print("Editar ${contact.name}");
            } else if (value == 3) {
              //DIALOGO ELIMINAR CONTACTO
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text(
                    "Atención",
                    style: theme.textTheme.headlineSmall,
                  ),
                  content: Text(
                      "Estás a punto de borrar un contacto, ¿Estás seguro?"),
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
          },
          //OPCIONES MENU CONTACTO
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
