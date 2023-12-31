// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, collection_methods_unrelated_type

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:agenda/models/funciones.dart';
import 'package:agenda/models/label.enum.dart';
import 'package:agenda/widgets/backgroundgradient.widget.dart';
import 'package:agenda/widgets/backgroundmessage.widget.dart';
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
                    agenda.notifyChanges();
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
                  List<String> currentLabels = _currentLabelsList(agenda);

                  return [
                    ...currentLabels.map((label) => PopupMenuItem(child:
                            StatefulBuilder(builder: (context, setState2) {
                          return SwitchListTile(
                              activeColor: theme.indicatorColor,
                              title: Text(label),
                              onChanged: (value) {
                                setState(() {
                                  setState2(() {
                                    _updateFilterLabels(
                                        agenda, label.toLowerCase());
                                  });
                                });
                              },
                              value: !agenda.filterLabels
                                  .contains(label.toLowerCase()));
                        }))),
                    PopupMenuItem(
                        child: StatefulBuilder(builder: (context, setState2) {
                      return SwitchListTile(
                          activeColor: theme.indicatorColor,
                          title: Text("No etiquetados"),
                          onChanged: (value) {
                            setState(() {
                              setState2(() {
                                _updateFilterLabels(agenda, "noLabels");
                              });
                            });
                          },
                          value: !agenda.filterLabels.contains("noLabels"));
                    }))
                  ];
                })
          ],
        ),
        body: agenda.contacts.isEmpty
            ? BackgroundGradient(
                primary: theme.colorScheme.primary,
                background: theme.colorScheme.background.withAlpha(100),
                child: BackgroundMessage(
                    title: Text("Agenda vacía", style: TextStyle(fontSize: 35)),
                    subtitle: Text("Toca \"+\" para añadir un contacto",
                        style: TextStyle(fontSize: 20)),
                    icon: Icon(Icons.account_box_rounded, size: 100)),
              )
            : TabBarView(children: <Widget>[
                //TAB LISTA CONTACTOS
                BackgroundGradient(
                  primary: theme.colorScheme.primary,
                  background: theme.colorScheme.background.withAlpha(100),
                  child: ListenableBuilder(
                      listenable: agenda,
                      builder: (context, child) {
                        List<ContactData> contactsFilter =
                            _contactsListFilter(agenda);

                        return contactsFilter.isEmpty
                            ? BackgroundMessage(
                                title: Text("Sin contactos que mostrar",
                                    style: TextStyle(fontSize: 30)),
                                subtitle: Text(
                                    "Cambia los filtros para mostrar contactos",
                                    style: TextStyle(fontSize: 17)),
                                icon: Icon(Icons.filter_alt_off_rounded,
                                    size: 100))
                            : ListView.builder(
                                itemCount: contactsFilter.length,
                                itemBuilder: (context, index) =>
                                    ListenableBuilder(
                                        listenable: contactsFilter[index],
                                        builder: (context, child) =>
                                            ContactTile(
                                                contact:
                                                    contactsFilter[index])));
                      }),
                ),
                //TAB LISTA FAVORITOS
                BackgroundGradient(
                  primary: theme.colorScheme.primary,
                  background: theme.colorScheme.background.withAlpha(100),
                  child: ListenableBuilder(
                      listenable: agenda,
                      builder: (context, child) {
                        List<ContactData> contactsFilter =
                            _contactsListFilter(agenda);

                        List<ContactData> listContactsFav = contactsFilter
                            .where((e) => e.isFavorite == true)
                            .toList();

                        return listContactsFav.isEmpty
                            ? BackgroundMessage(
                                title: Text("Sin favoritos",
                                    style: TextStyle(fontSize: 35)),
                                subtitle: Text(
                                    "Aquí saldrán tus contactos favoritos",
                                    style: TextStyle(fontSize: 20)),
                                icon: Icon(Icons.star, size: 100))
                            : ListView.builder(
                                itemCount: listContactsFav.length,
                                itemBuilder: (context, index) =>
                                    ListenableBuilder(
                                        listenable: listContactsFav[index],
                                        builder: (context,
                                                child) =>
                                            ContactTile(
                                                contact:
                                                    listContactsFav[index])));
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

  void _updateFilterLabels(AgendaData agenda, String label) {
    agenda.filterLabels.contains(label)
        ? agenda.filterLabels.remove(label)
        : agenda.filterLabels.add(label);
    //agenda.notifyChanges();
  }

  List<ContactData> _contactsListFilter(AgendaData agenda) {
    List<ContactData> contactsFilter = agenda.contacts.where((e) {
      List<String> labelPriorityList = (e.labels ?? [])
        ..sort((a, b) => Label.parse(a).compareTo(Label.parse(b)));
      String firstLabel =
          labelPriorityList.isNotEmpty ? labelPriorityList[0] : 'noLabels';
      return !agenda.filterLabels.contains(firstLabel);
    }).toList();
    return contactsFilter;
  }

  List<String> _currentLabelsList(AgendaData agenda) {
    List<String> currentLabels = agenda.contacts
        .fold<List<String>>([], (ac, e) => [...ac, ...(e.labels ?? [])])
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .toSet()
        .toList()
      ..sort((a, b) => diacriticsCaseAwareCompareTo(a, b));
    return currentLabels;
  }
}
