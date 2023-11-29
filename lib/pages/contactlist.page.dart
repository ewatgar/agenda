// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:agenda/widgets/commonbody.widget.dart';
import 'package:flutter/material.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(title: Text("Agenda")),
          body: TabBarView(children: <Widget>[
            CommonBody(child: Center(child: Text("Lista contactos WIP"))),
            CommonBody(child: Center(child: Text("Lista favoritos WIP")))
          ]),
          bottomNavigationBar: Ink(
            color: Theme.of(context).colorScheme.primary,
            child: TabBar(tabs: [
              Tab(text: "Contactos"),
              Tab(text: "Favoritos"),
            ]),
          )),
    );
  }
}
