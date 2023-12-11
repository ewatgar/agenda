// ignore_for_file: prefer_const_constructors

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContactCreationPage extends StatefulWidget {
  const ContactCreationPage({super.key});

  @override
  State<ContactCreationPage> createState() => _ContactCreationPageState();
}

class _ContactCreationPageState extends State<ContactCreationPage> {
  late TextEditingController contactNameController;
  late TextEditingController contactSurnameController;
  late TextEditingController contactPhoneController;
  late TextEditingController contactEmailController;
  late TextEditingController contactBirthdateController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late DateTime? birthdate;
  DateFormat dateFormat = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    birthdate = null;
    contactNameController = TextEditingController();
    contactSurnameController = TextEditingController();
    contactPhoneController = TextEditingController();
    contactEmailController = TextEditingController();
    contactBirthdateController = TextEditingController(
        text: birthdate != null ? dateFormat.format(birthdate!) : null);
  }

  @override
  Widget build(BuildContext context) {
    AgendaData agenda = Provider.of<AgendaData>(context);
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo contacto"),
        actions: [
          IconButton(
              onPressed: () {
                ContactData newContact = ContactData(
                    id: agenda.contacts.last.id++,
                    name: contactNameController.text,
                    surname: contactSurnameController.text,
                    phone: contactPhoneController.text,
                    email: contactEmailController.text,
                    birthdate: birthdate,
                    creation: DateTime.now());
                agenda.contacts.add(newContact);
                agenda.notifyChanges();
                Navigator.of(context).pop<bool>(true);
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Nombre"),
              controller: contactNameController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Apellidos"),
              controller: contactSurnameController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Teléfono"),
              controller: contactPhoneController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Email"),
              controller: contactEmailController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Fecha de nacimiento"),
              controller: contactBirthdateController,
              readOnly: true,
              onTap: () async {
                DateTime? dateSelected = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now());

                if (dateSelected != null) {
                  birthdate = dateSelected;
                  contactBirthdateController.text =
                      dateFormat.format(birthdate ?? DateTime.now());
                }
              },
            ),
          ],
        ),
      )),
    );
  }
}
