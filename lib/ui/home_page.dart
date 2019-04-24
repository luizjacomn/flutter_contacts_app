import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:flutter_contacts/util/contact_util.dart';

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
  final _addIcon = Icons.person_add;
  final _contactsIcon = Icons.contacts;
  final _menuIcon = Icons.more_vert;

  ContactUtil util = ContactUtil();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    util.findAll().then((list) {
      print(list);
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _deepGray,
      appBar: AppBar(
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
          IconButton(
            icon: Icon(
              _menuIcon,
              color: _darkGray,
            ),
            onPressed: () {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
}
