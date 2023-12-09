// ignore_for_file: prefer_const_constructors

import 'package:agenda/models/agenda.data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactCreationPage extends StatefulWidget {
  const ContactCreationPage({super.key});

  @override
  State<ContactCreationPage> createState() => _ContactCreationPageState();
}

class _ContactCreationPageState extends State<ContactCreationPage> {
  late TextEditingController contactNameController;

  @override
  void initState() {
    super.initState();
    AgendaData agenda = Provider.of<AgendaData>(context);
    contactNameController = TextEditingController();
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
              decoration: InputDecoration(labelText: "Fecha de nacimiento"),
            ),
          ],
        ),
      )),
    );
  }
}
