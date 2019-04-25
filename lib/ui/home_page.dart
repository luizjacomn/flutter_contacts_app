import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:flutter_contacts/ui/contact_page.dart';
import 'package:flutter_contacts/util/contact_util.dart';
import 'package:url_launcher/url_launcher.dart';

enum Order {ASC, DESC}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _deepGray = Colors.blueGrey[900];
  final _darkGray = Colors.blueGrey[800];
  final _gray = Colors.blueGrey[200];
  final _amber = Colors.amber;
  final _white = Colors.white;
  final _red = Colors.redAccent;

  final _addIcon = Icons.person_add;
  final _contactsIcon = Icons.contacts;

  final _callIcon = Icons.phone;
  final _editIcon = Icons.edit;
  final _removeIcon = Icons.restore_from_trash;

  ContactUtil util = ContactUtil();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _findAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _deepGray,
      appBar: AppBar(
        iconTheme: IconThemeData(color: _deepGray),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              _contactsIcon,
              color: _deepGray,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Contatos',
                style: TextStyle(color: _deepGray),
              ),
            )
          ],
        ),
        backgroundColor: _amber,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Order>(
            itemBuilder: (context) => <PopupMenuEntry<Order>>[
              const PopupMenuItem<Order>(
                child: Text("Ordenar A-Z"),
                value: Order.ASC,
              ),
              const PopupMenuItem<Order>(
                child: Text("Ordenar Z-A"),
                value: Order.DESC,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(
          _addIcon,
          color: _deepGray,
        ),
        backgroundColor: _amber,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        color: _darkGray,
        elevation: 6.0,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].photo != null
                        ? FileImage(File(contacts[index].photo))
                        : AssetImage('images/default_user.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? '',
                      style: TextStyle(
                          color: _white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ?? '',
                      style: TextStyle(color: _gray, fontSize: 18.0),
                    ),
                    Text(
                      contacts[index].phone ?? '',
                      style: TextStyle(color: _gray, fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _findAllContacts() {
    util.findAll().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showContactPage({Contact contact}) async {
    final readContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));

    if (readContact != null) {
      contact != null
          ? await util.update(readContact)
          : await util.save(readContact);

      _findAllContacts();
    }
  }

  void _orderList(Order order){
    switch(order){
      case Order.ASC:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case Order.DESC:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(color: _darkGray),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: FlatButton(
                          onPressed: () {
                            launch('tel: ${contacts[index].phone}');
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                _callIcon,
                                color: _amber,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Ligar',
                                  style:
                                      TextStyle(color: _amber, fontSize: 20.0),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showContactPage(contact: contacts[index]);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                _editIcon,
                                color: _amber,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Editar',
                                  style:
                                      TextStyle(color: _amber, fontSize: 20.0),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: FlatButton(
                          onPressed: () {
                            util.delete(contacts[index].id);
                            setState(() {
                              contacts.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                _removeIcon,
                                color: _red,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Excluir',
                                  style: TextStyle(color: _red, fontSize: 20.0),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
