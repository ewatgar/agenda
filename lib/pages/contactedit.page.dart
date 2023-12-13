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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late DateTime? birthdate;
  DateFormat dateFormat = DateFormat.yMMMd();

  late bool newChanges;

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
    newChanges = false;
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
        return _leavePageAsk(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              widget.isNew ? Text("Nuevo contacto") : Text("Editar contacto"),
          actions: [
            IconButton(
                onPressed: () {
                  if (newChanges) {
                    _onSaveChanges(agenda, context);
                  }
                },
                icon: newChanges
                    ? Icon(Icons.check)
                    : Icon(Icons.check, color: Colors.white.withAlpha(70)))
          ],
        ),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Nombre"),
                    controller: contactNameController,
                    onChanged: (value) {
                      setState(() {
                        widget.isNew
                            ? newChanges = contactNameController.text != ''
                            : newChanges =
                                contactNameController.text != copy.name;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Apellidos"),
                    controller: contactSurnameController,
                    onChanged: (value) {
                      setState(() {
                        widget.isNew
                            ? newChanges = contactSurnameController.text != ''
                            : newChanges =
                                contactSurnameController.text != copy.surname;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Teléfono"),
                    controller: contactPhoneController,
                    onChanged: (value) {
                      setState(() {
                        widget.isNew
                            ? newChanges = contactPhoneController.text != ''
                            : newChanges =
                                contactPhoneController.text != copy.phone;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    controller: contactEmailController,
                    onChanged: (value) {
                      setState(() {
                        widget.isNew
                            ? newChanges = contactEmailController.text != ''
                            : newChanges =
                                contactEmailController.text != copy.email;
                      });
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: "Fecha de nacimiento"),
                    controller: contactBirthdateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? dateSelected = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());

                      if (dateSelected != null) {
                        setState(() {
                          birthdate = dateSelected;
                          contactBirthdateController.text =
                              dateFormat.format(birthdate ?? DateTime.now());

                          newChanges = birthdate != copy.birthdate;
                        });
                      } else {
                        newChanges = false;
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
    if (newChanges) {
    } else {
      Navigator.pop(context);
    }
    return Future.value(true);
  }

  void _onSaveChanges(AgendaData agenda, BuildContext context) {
    if (newChanges) {
      _saveContactInfo(agenda);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: widget.isNew
            ? Text("Contacto creado con éxito")
            : Text("Contacto editado con éxito"),
      ));
    }
    Navigator.of(context).pop<bool>(true);
  }

  void _saveContactInfo(AgendaData agenda) {
    if (widget.isNew) {
      copy.id = agenda.contacts.fold<int>(0, (ac, e) {
            if (e.id > ac) ac = e.id;
            return ac;
          }) +
          1;
    }
    widget.contact.name =
        contactNameController.text.isEmpty ? null : contactNameController.text;
    widget.contact.surname = contactSurnameController.text.isEmpty
        ? null
        : contactSurnameController.text;
    widget.contact.email = contactEmailController.text.isEmpty
        ? null
        : contactEmailController.text;
    widget.contact.phone = contactPhoneController.text.isEmpty
        ? null
        : contactPhoneController.text;
    widget.contact.birthdate = birthdate;
    widget.isNew
        ? widget.contact.creation = DateTime.now()
        : widget.contact.modification = DateTime.now();
  }
}
