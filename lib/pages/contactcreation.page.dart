// ignore_for_file: prefer_const_constructors

import 'package:agenda/models/agenda.data.dart';
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
  late TextEditingController contactBirthdateController;

  late DateTime birthdate;
  DateFormat dateFormat = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    birthdate = DateTime.now();
    contactNameController = TextEditingController();
    contactBirthdateController =
        TextEditingController(text: dateFormat.format(birthdate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo contacto"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.check))],
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Apellidos"),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Teléfono"),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              controller: contactBirthdateController,
              readOnly: true,
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: birthdate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (newDate != null) {
                  birthdate = newDate;
                  contactBirthdateController.text =
                      dateFormat.format(birthdate);
                }
              },
              decoration: InputDecoration(labelText: "Fecha de nacimiento"),
            ),
          ],
        ),
      )),
    );
  }
}
