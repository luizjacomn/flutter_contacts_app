class Contact {
  static final idColumn = 'id';
  static final nameColumn = 'name';
  static final emailColumn = 'email';
  static final phoneColumn = 'phone';
  static final photoColumn = 'photo';
  static final contactTable = 'contactTable';

  int _id;
  String _name;
  String _email;
  String _phone;
  String _photo;

  Contact();

  Contact.fill(this._name, this._email, this._phone);

  Contact.fromMap(Map map) {
    _id = map[idColumn];
    _name = map[nameColumn];
    _email = map[emailColumn];
    _phone = map[phoneColumn];
    _photo = map[photoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: _name,
      emailColumn: _email,
      phoneColumn: _phone,
      photoColumn: _photo
    };

    if (_id != null) {
      map[idColumn] = _id;
    }

    return map;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  @override
  String toString() {
    return 'Contact{_id: $_id, _name: $_name, _email: $_email, _phone: $_phone}';
  }
}