import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/model/contact.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _deepGray = Colors.blueGrey[900];
  final _darkGray = Colors.blueGrey[800];
  final _gray = Colors.blueGrey[200];
  final _amber = Colors.amber;
  final _white = Colors.white;
  final _saveIcon = Icons.save;
  final _contactsIcon = Icons.contacts;
  final _menuIcon = Icons.more_vert;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  Contact _edited;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();

    widget.contact == null
        ? _edited = Contact()
        : _edited = Contact.fromMap(widget.contact.toMap());

    _nameController.text = _edited.name;
    _emailController.text = _edited.email;
    _phoneController.text = _edited.phone;

    //TODO INICIANDO AULA 17.11
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
                _edited.name ?? 'Novo Contato',
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
          _saveIcon,
          color: _deepGray,
        ),
        backgroundColor: _amber,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                child: Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _edited.photo != null
                          ? FileImage(File(_edited.photo))
                          : AssetImage('images/default_user.png'),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      _isEdited = true;
                      setState(() {
                        _edited.name = text;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Nome', labelStyle: TextStyle(color: _gray)),
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      _isEdited = true;
                      _edited.email = text;
                    },
                    decoration: InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: TextStyle(color: _gray)),
                  ),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    onChanged: (text) {
                      _isEdited = true;
                      _edited.phone = text;
                    },
                    decoration: InputDecoration(
                        labelText: 'Telefone',
                        labelStyle: TextStyle(color: _gray)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
