// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, collection_methods_unrelated_type

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:agenda/models/diacriticsCaseAwareCompareTo.fun.dart';
import 'package:agenda/models/label.enum.dart';
import 'package:agenda/pages/contactcreation.page.dart';
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

    return StatefulBuilder(builder: (context, setState) {
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
                    List<String> currentLabels = agenda.contacts
                        .fold<List<String>>(
                            [], (ac, e) => [...ac, ...(e.labels ?? [])])
                        .map((e) => e[0].toUpperCase() + e.substring(1))
                        .toSet()
                        .toList()
                      ..sort((a, b) => diacriticsCaseAwareCompareTo(a, b));

                    return [
                      ...currentLabels.map((label) => PopupMenuItem(child:
                              StatefulBuilder(builder: (context, setState) {
                            return SwitchListTile(
                                activeColor: theme.indicatorColor,
                                title: Text(label),
                                onChanged: (value) {
                                  setState(() {
                                    agenda.filterLabels
                                            .contains(label.toLowerCase())
                                        ? agenda.filterLabels
                                            .remove(label.toLowerCase())
                                        : agenda.filterLabels
                                            .add(label.toLowerCase());
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
                    //LOGICA FILTRO CONTACTOS
                    List<ContactData> contactsFilter =
                        agenda.contacts.where((e) {
                      List<String> labelPriorityList = (e.labels ?? [])
                        ..sort(
                            (a, b) => Label.parse(a).compareTo(Label.parse(b)));
                      String firstLabel = labelPriorityList.isNotEmpty
                          ? labelPriorityList[0]
                          : 'noLabels';
                      return !agenda.filterLabels.contains(firstLabel);
                    }).toList();
                    //LISTA CONTACTOS FILTRO
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
                    //LOGICA FILTRO FAVORITOS
                    List<ContactData> contactsFilter =
                        agenda.contacts.where((e) {
                      List<String> labelPriorityList = (e.labels ?? [])
                        ..sort(
                            (a, b) => Label.parse(a).compareTo(Label.parse(b)));
                      String firstLabel = labelPriorityList.isNotEmpty
                          ? labelPriorityList[0]
                          : 'noLabels';
                      return !agenda.filterLabels.contains(firstLabel);
                    }).toList();

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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactCreationPage()));
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          //TABS
          bottomNavigationBar: TabBar(tabs: [
            Tab(text: "Contactos", icon: Icon(Icons.contacts)),
            Tab(text: "Favoritos", icon: Icon(Icons.star)),
          ]),
        ),
      );
    });
  }
}
