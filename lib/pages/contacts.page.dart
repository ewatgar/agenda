// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, collection_methods_unrelated_type

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:agenda/models/funciones.dart';
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
            //BOTON ORDENAR
            IconButton(
                onPressed: () {
                  setState(() {
                    agenda.isSortedAZ ? agenda.sortZA() : agenda.sortAZ();
                  });
                },
                icon: Icon(agenda.isSortedAZ
                    ? FontAwesomeIcons.arrowDownZA
                    : FontAwesomeIcons.arrowDownAZ)),
            //MENU FILTROS ETIQUETAS
            PopupMenuButton(
                icon: Icon(Icons.filter_alt),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                itemBuilder: (context) {
                  List<String> currentLabels = currentLabelsList(agenda);

                  return [
                    ...currentLabels.map((label) => PopupMenuItem(child:
                            StatefulBuilder(builder: (context, setState2) {
                          return SwitchListTile(
                              activeColor: theme.indicatorColor,
                              title: Text(label),
                              onChanged: (value) {
                                setState(() {
                                  setState2(() {
                                    agenda.filterLabels
                                            .contains(label.toLowerCase())
                                        ? agenda.filterLabels
                                            .remove(label.toLowerCase())
                                        : agenda.filterLabels
                                            .add(label.toLowerCase());
                                  });
                                });
                              },
                              value: !agenda.filterLabels
                                  .contains(label.toLowerCase()));
                        }))),
                    PopupMenuItem(
                        child: StatefulBuilder(builder: (context, setState) {
                      return SwitchListTile(
                          activeColor: theme.indicatorColor,
                          title: Text("No etiquetados"),
                          onChanged: (value) {
                            setState(() {
                              agenda.filterLabels.contains("noLabels")
                                  ? agenda.filterLabels.remove("noLabels")
                                  : agenda.filterLabels.add("noLabels");
                            });
                          },
                          value: !agenda.filterLabels.contains("noLabels"));
                    }))
                  ];
                })
          ],
        ),
        body: TabBarView(children: <Widget>[
          //TAB LISTA CONTACTOS
          BackgroundGradient(
            primary: theme.colorScheme.primary,
            background: theme.colorScheme.background.withAlpha(100),
            child: ListenableBuilder(
                listenable: agenda,
                builder: (context, child) {
                  List<ContactData> contactsFilter = contactsListFilter(agenda);

                  return ListView.builder(
                      itemCount: contactsFilter.length,
                      itemBuilder: (context, index) => ListenableBuilder(
                          listenable: contactsFilter[index],
                          builder: (context, child) =>
                              ContactTile(contact: contactsFilter[index])));
                }),
          ),
          //TAB LISTA FAVORITOS
          BackgroundGradient(
            primary: theme.colorScheme.primary,
            background: theme.colorScheme.background.withAlpha(100),
            child: ListenableBuilder(
                listenable: agenda,
                builder: (context, child) {
                  List<ContactData> contactsFilter = contactsListFilter(agenda);

                  List<ContactData> listContactsFav = contactsFilter
                      .where((e) => e.isFavorite == true)
                      .toList();

                  return ListView.builder(
                    itemCount: listContactsFav.length,
                    itemBuilder: (context, index) {
                      ContactData contactFav = listContactsFav[index];
                      return ContactTile(contact: contactFav);
                    },
                  );
                }),
          )
        ]),
        //FAB CREAR CONTACTO
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 70, 70, 70),
          foregroundColor: theme.indicatorColor,
          onPressed: () {
            navigateToContactCreation(context, agenda);
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //TABS
        bottomNavigationBar: TabBar(tabs: [
          Tab(text: "Contactos", icon: Icon(Icons.contacts)),
          Tab(text: "Favoritos", icon: Icon(Icons.star)),
        ]),
      ),
    );
  }
}
