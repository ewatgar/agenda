// ignore_for_file: prefer_const_constructors, avoid_print, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

class ContactDetailsPage extends StatefulWidget {
  const ContactDetailsPage({super.key});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late TextEditingController emailContactController;

  //keys para la reorganización manual de la lista (arrastrar elementos)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailContactController = TextEditingController(text: "Valor inicial");
  }

  @override
  void dispose() {
    super.dispose();
    emailContactController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle de contacto"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.save))],
      ),
      body: Form(
          child: Column(
        children: [
          TextFormField(
            controller: emailContactController,
            validator: _onValidateEmailContact,
            decoration: InputDecoration(
              labelText: "email",
              hintText: "hint",
              border: OutlineInputBorder(),
            ),
          )
        ],
      )),
    );
  }

  void _onSave() {
    //se necesita un controlador para cada campo del formulario
    if (_formKey.currentState!.validate()) {
      print("PERFECTO, todos los campos estan bien");
      //widget.aditivo.codigo = codAditivoController.text;
    } else {
      print("Algun campo no está bien");
    }
    print(emailContactController.text);
  }

  void _saveChanges(BuildContext context) {
    Navigator.of(context).pop<bool>(true);
  }

  void _cancelChanges(BuildContext context) {
    Navigator.of(context).pop<bool>(false);
  }

  String? _onValidateObligatorio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Campo obligatorio";
    }
    return null;
  }

  String? _onValidateEmailContact(String? value) {
    //TODO implementar check email regex
    if (value == null || value.trim().isEmpty) {
      return "Campo obligatorio";
    }
    //buscar regex email

    return null;
  }
}
