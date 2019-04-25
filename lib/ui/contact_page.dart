import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _deepGray = Colors.blueGrey[900];
  final _amber = Colors.amber;
  final _white = Colors.white;
  final _saveIcon = Icons.save;
  final _contactsIcon = Icons.supervised_user_circle;
  final _nameIcon = Icons.person_outline;
  final _emailIcon = Icons.mail_outline;
  final _phoneIcon = Icons.phone_android;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: _deepGray,
        appBar: AppBar(
          iconTheme: IconThemeData(color: _deepGray),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                _contactsIcon,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  _edited.name == null ? 'Novo Contato' : 'Editar',
                  style: TextStyle(color: _deepGray),
                ),
              )
            ],
          ),
          backgroundColor: _amber,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if ((_edited.name != null && _edited.name.isNotEmpty) &&
                ((_edited.email != null && _edited.email.isNotEmpty) ||
                    (_edited.phone != null && _edited.phone.isNotEmpty)))
              Navigator.pop(context, _edited);
            else
              FocusScope.of(context).requestFocus(_nameFocus);
          },
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
                  onTap: () {
                    ImagePicker.pickImage(
                      source: ImageSource.gallery,
                    ).then((file) {
                      if (file == null) return;
                      setState(() {
                        _edited.photo = file.path;
                      });
                    });
                  },
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
                      textCapitalization: TextCapitalization.words,
                      controller: _nameController,
                      focusNode: _nameFocus,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: _white),
                      onChanged: (text) {
                        _isEdited = true;
                        setState(() {
                          _edited.name = text;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            _nameIcon,
                            color: _amber,
                          ),
                          labelText: 'Nome',
                          labelStyle: TextStyle(color: _amber)),
                    ),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: _white),
                      onChanged: (text) {
                        _isEdited = true;
                        _edited.email = text;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(_emailIcon, color: _amber),
                          labelText: 'E-mail',
                          labelStyle: TextStyle(color: _amber)),
                    ),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: _white),
                      onChanged: (text) {
                        _isEdited = true;
                        _edited.phone = text;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(_phoneIcon, color: _amber),
                          labelText: 'Telefone',
                          labelStyle: TextStyle(color: _amber)),
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

  Future<bool> _requestPop() async {
    if (_isEdited) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar alterações?'),
              content: Text("Caso saia, as alterações serão perdidas!"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Não'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Sim'),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
