// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:agenda/widgets/backgroundgradient.widget.dart';
import 'package:agenda/widgets/contacttile.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    AgendaData agenda = Provider.of<AgendaData>(context);
    ThemeData theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Agenda"),
          actions: [
            IconButton(
                onPressed: () {}, icon: Icon(FontAwesomeIcons.arrowDownAZ)),
            IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt))
          ],
        ),
        body: TabBarView(children: <Widget>[
          //TABVIEW CONTACTOS
          BackgroundGradient(
            primary: theme.colorScheme.primary,
            background: theme.colorScheme.background.withAlpha(100),
            child: ListenableBuilder(
                listenable: agenda,
                builder: (context, child) {
                  return ListView.builder(
                    itemCount: agenda.contacts.length,
                    itemBuilder: (context, index) {
                      ContactData contact = agenda.contacts[index];
                      return ContactTile(contact: contact);
                    },
                  );
                }),
          ),
          //TABVIEW FAVORITOS
          BackgroundGradient(
              primary: theme.colorScheme.primary,
              background: theme.colorScheme.background.withAlpha(100),
              child: Text("lmao"))
        ]),
        bottomNavigationBar: TabBar(tabs: [
          Tab(text: "Contactos", icon: Icon(Icons.contacts)),
          Tab(text: "Favoritos", icon: Icon(Icons.star)),
        ]),
      ),
    );
  }
}
