// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:agenda/models/contact.data.dart';
import 'package:agenda/widgets/labelicon.widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContactDetailsPage extends StatefulWidget {
  const ContactDetailsPage({super.key, required this.contact});

  final ContactData contact;

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late ContactData copy;

  @override
  void initState() {
    super.initState();
    copy = widget.contact.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    //ContactData copy = widget.contact.copyWith();
    DateFormat format = DateFormat("MMM dd, yyyy");

    String strLabels = widget.contact.labels
            ?.map((e) => e[0].toUpperCase() + e.substring(1))
            .reduce((value, element) => element += ", $value") ??
        "n/a";

    return WillPopScope(
      onWillPop: () {
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("prueba")));
        widget.contact.isFavorite = copy.isFavorite;
        widget.contact.modification = DateTime.now();
        Navigator.pop(context);
        return Future.value(true);
      },
      child: ListenableBuilder(
          listenable: widget.contact,
          builder: (context, child) {
            return Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            copy.isFavorite = !copy.isFavorite;
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
                        child:
                            LabelIcon(labels: widget.contact.labels, size: 100),
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
                    ListTile(
                      title: Text("Nacimiento",
                          style: theme.textTheme.titleMedium),
                      subtitle: Text(
                          widget.contact.birthdate != null
                              ? format.format(widget.contact.birthdate!)
                              : "n/a",
                          style: theme.textTheme.headlineSmall),
                    ),
                    /*Row(
                      children: [ListTile(title: Text("a")), Text("b")],
                    )*/
                    Divider(thickness: 2),
                    ListTile(
                      title:
                          Text("Etiquetas", style: theme.textTheme.titleMedium),
                      subtitle:
                          Text(strLabels, style: theme.textTheme.headlineSmall),
                    ),
                    Divider(thickness: 2),
                    Center(
                        child: Text("Añadido en ${widget.contact.creation}")),
                    SizedBox(height: 5),
                    Center(
                        child:
                            Text("Editado en ${widget.contact.modification}")),
                  ],
                ));
          }),
    );
  }
}
