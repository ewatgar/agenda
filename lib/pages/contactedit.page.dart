// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContactEditPage extends StatefulWidget {
  const ContactEditPage({super.key, required this.contact, this.isNew = false});

  final ContactData contact;
  final bool isNew;

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
  void dispose() {
    contactNameController.dispose();
    contactSurnameController.dispose();
    contactPhoneController.dispose();
    contactEmailController.dispose();
    contactBirthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AgendaData agenda = Provider.of<AgendaData>(context);

    return WillPopScope(
      onWillPop: () {
        return _leavePageAsk(context, widget.contact);
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              widget.isNew ? Text("Nuevo contacto") : Text("Editar contacto"),
          actions: [
            IconButton(
                onPressed: () {
                  _onSaveChanges(agenda, context);
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
      ),
    );
  }

  Future<bool> _leavePageAsk(BuildContext context) {
    if (!widget.contact.equals(copy)) {}
    Navigator.pop(context);
    return Future.value(true);
  }

  void _onSaveChanges(AgendaData agenda, BuildContext context) {
    //check si vacio o no ha habido cambios (al salir)

    //sacar mayor valor id
    if (widget.isNew)
      widget.contact.id = agenda.contacts.fold<int>(0, (ac, e) {
            if (e.id > ac) ac = e.id;
            return ac;
          }) +
          1;
    widget.contact.name = contactNameController.text;
    widget.contact.surname = contactSurnameController.text;
    widget.contact.email = contactEmailController.text;
    widget.contact.phone = contactPhoneController.text;
    widget.contact.birthdate = birthdate;
    widget.isNew
        ? widget.contact.creation = DateTime.now()
        : widget.contact.modification = DateTime.now();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: widget.isNew
          ? Text("Contacto creado con éxito")
          : Text("Contacto editado"),
    ));
    Navigator.of(context).pop<bool>(true);
  }
}
