// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:agenda/models/funciones.dart';
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
      onWillPop: () async {
        if (newChanges) {
          return await leavePageAsk(context) ?? false;
        }
        Navigator.of(context).pop(false);
        return false;
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
                        _checkNewChanges(contactNameController, copy.name);
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Apellidos"),
                    controller: contactSurnameController,
                    onChanged: (value) {
                      setState(() {
                        _checkNewChanges(
                            contactSurnameController, copy.surname);
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Teléfono"),
                    controller: contactPhoneController,
                    onChanged: (value) {
                      setState(() {
                        _checkNewChanges(contactPhoneController, copy.phone);
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    controller: contactEmailController,
                    validator: _onValidateContactEmail,
                    onChanged: (value) {
                      setState(() {
                        _checkNewChanges(contactEmailController, copy.email);
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

  void _checkNewChanges(TextEditingController controller, String? copyValue) {
    newChanges = widget.isNew
        ? controller.text.isNotEmpty
        : controller.text != copyValue;
  }

  void _onSaveChanges(AgendaData agenda, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _saveContactInfo(agenda);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: widget.isNew
            ? Text("Contacto creado con éxito")
            : Text("Contacto editado con éxito"),
      ));
      Navigator.of(context).pop<bool>(true);
    }
  }

  void _saveContactInfo(AgendaData agenda) {
    if (widget.isNew) {
      widget.contact.id = agenda.contacts.fold<int>(0, (ac, e) {
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

  String? _onValidateContactEmail(String? value) {
    RegExp exp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value == null || value.trim().isEmpty || exp.hasMatch(value)) {
      return null;
    } else {
      return "Formato de email incorrecto";
    }
  }
}
