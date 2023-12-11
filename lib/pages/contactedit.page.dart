// ignore_for_file: prefer_const_constructors

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContactEditPage extends StatefulWidget {
  const ContactEditPage({super.key, required this.contact});

  final ContactData contact;

  @override
  State<ContactEditPage> createState() => _ContactEditPageState();
}

class _ContactEditPageState extends State<ContactEditPage> {
  late ContactData copy;
  late TextEditingController contactNameController;
  late TextEditingController contactSurnameController;
  late TextEditingController contactPhoneController;
  late TextEditingController contactEmailController;
  late TextEditingController contactBirthdateController;
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late DateTime? birthdate;
  DateFormat dateFormat = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    copy = widget.contact.copyWith();
    birthdate = copy.birthdate;
    contactNameController = TextEditingController(text: copy.name);
    contactSurnameController = TextEditingController(text: copy.surname);
    contactPhoneController = TextEditingController(text: copy.phone);
    contactEmailController = TextEditingController(text: copy.email);
    contactBirthdateController = TextEditingController(
        text: birthdate != null ? dateFormat.format(birthdate!) : null);
  }

  @override
  Widget build(BuildContext context) {
    AgendaData agenda = Provider.of<AgendaData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo contacto"),
        actions: [
          IconButton(
              onPressed: () {
                widget.contact.name = contactNameController.text;
                widget.contact.surname = contactSurnameController.text;
                widget.contact.email = contactEmailController.text;
                widget.contact.phone = contactPhoneController.text;
                widget.contact.birthdate = birthdate;
                widget.contact.modification = DateTime.now();
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

/*
  void _onCreateContact(AgendaData agenda, BuildContext context) {
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
  }*/
}
