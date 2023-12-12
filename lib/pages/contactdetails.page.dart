// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:agenda/models/contact.data.dart';
import 'package:agenda/widgets/labelicon.widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactDetailsPage extends StatefulWidget {
  const ContactDetailsPage({super.key, required this.contact});

  final ContactData contact;

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late ContactData copy;
  late String labelsText;
  bool modified = false;

  @override
  void initState() {
    super.initState();
    copy = widget.contact.copyWith();
    labelsText = "";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DateFormat birthdateFormat = DateFormat.yMMMd();
    DateFormat creatModifFormat = DateFormat('yyyy-MM-dd HH:mm');
    String strLabels = (copy.labels ?? []).isNotEmpty
        ? copy.labels!
            .map((e) => e[0].toUpperCase() + e.substring(1))
            .join(", ")
        : "n/a";

    return WillPopScope(
      onWillPop: () {
        return _leavePageSave(context);
      },
      child: ListenableBuilder(
          listenable: widget.contact,
          builder: (context, child) {
            return Scaffold(
                appBar: AppBar(
                  actions: [
                    //BOTON EDITAR
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                    //BOTON FAVORITO
                    IconButton(
                        onPressed: () {
                          setState(() {
                            copy.isFavorite = !copy.isFavorite;
                            modified = true;
                          });
                        },
                        icon: Icon(
                            copy.isFavorite ? Icons.star : Icons.star_border))
                  ],
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: CircleAvatar(
                        radius: 100,
                        child: LabelIcon(labels: copy.labels, size: 100),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          "${widget.contact.name} ${widget.contact.surname}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  theme.textTheme.headlineMedium!.fontSize),
                        ),
                      ),
                    ),
                    Divider(thickness: 2),
                    ListTile(
                        title: Text("Correo electrónico",
                            style: theme.textTheme.titleMedium),
                        subtitle: Text(widget.contact.email ?? "n/a",
                            style: theme.textTheme.headlineSmall),
                        trailing: Icon(Icons.email)),
                    Divider(thickness: 2),
                    ListTile(
                        title: Text("Teléfono",
                            style: theme.textTheme.titleMedium),
                        subtitle: Text(widget.contact.phone ?? "n/a",
                            style: theme.textTheme.headlineSmall),
                        trailing: Icon(Icons.phone)),
                    Divider(thickness: 2),

                    //TODO: falta edad
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ListTile(
                            title: Text("Nacimiento",
                                style: theme.textTheme.titleMedium),
                            subtitle: Text(
                                widget.contact.birthdate != null
                                    ? birthdateFormat
                                        .format(widget.contact.birthdate!)
                                    : "n/a",
                                style: theme.textTheme.headlineSmall),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: ListTile(
                              title: Text("Edad"),
                              subtitle: Text(),
                            ))
                      ],
                    ),
                    Divider(thickness: 2),
                    ListTile(
                      onTap: () {
                        _showModalBottomSheetLabels(context, strLabels);
                      },
                      title:
                          Text("Etiquetas", style: theme.textTheme.titleMedium),
                      subtitle:
                          Text(strLabels, style: theme.textTheme.headlineSmall),
                    ),
                    Divider(thickness: 2),
                    if (widget.contact.creation != null)
                      Center(
                          child: Text(
                              "Añadido en ${creatModifFormat.format(widget.contact.creation!)}")),
                    SizedBox(height: 5),
                    if (widget.contact.modification != null)
                      Center(
                          child: Text(
                              "Editado en ${creatModifFormat.format(widget.contact.modification!)}")),
                  ],
                ));
          }),
    );
  }

  Future<bool> _leavePageSave(BuildContext context) {
    if (modified) {
      widget.contact.isFavorite = copy.isFavorite;
      widget.contact.labels = copy.labels;
      widget.contact.modification = DateTime.now();
    }
    Navigator.pop(context);
    return Future.value(true);
  }

  Future<dynamic> _showModalBottomSheetLabels(
      BuildContext context, String strLabels) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 150,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                //TEXTFORMFIELD LABELS
                TextFormField(
                  initialValue: strLabels,
                  onChanged: (value) {
                    labelsText = value;
                    modified = true;
                  },
                ),
                SizedBox(height: 10),
                //BOTON APLICAR
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _applyLabels(context);
                      });
                    },
                    child: Text("Aplicar"))
              ],
            ),
          ),
        );
      },
    );
  }

  void _applyLabels(BuildContext context) {
    copy.labels = labelsText
        .split(",")
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();
    modified = true;
    Navigator.of(context).pop();
  }
}
