import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yego Form',
      initialRoute: '/',
      routes: {
        '/': (context) => YegoForm(),
        '/saved_data': (context) => SavedDataScreen(),
      },
    );
  }
}

class YegoForm extends StatefulWidget {
  @override
  _YegoFormState createState() => _YegoFormState();
}

class _YegoFormState extends State<YegoForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _surname = '';
  double _level = 0.0;
  File? _image;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    final RegExp nameExp = RegExp(r'^[a-zA-Z]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter only letters';
    }
    return null;
  }

  String? _validateSurname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your surname';
    }
    final RegExp surnameExp = RegExp(r'^[a-zA-Z]+$');
    if (!surnameExp.hasMatch(value)) {
      return 'Please enter only letters';
    }
    return null;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(
        context,
        '/saved_data',
        arguments: {
          'name': _name,
          'surname': _surname,
          'level': _level,
          'image': _image,
        },
      );
    }
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Yego Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _getImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(Icons.person, size: 50.0)
                          : null,
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          _level.toInt().toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: _validateName,
                onSaved: (value) {
                  setState(() {
                    _name = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Surname'),
                validator: _validateSurname,
                onSaved: (value) {
                  setState(() {
                    _surname = value!;
                  });
                },
              ),
              Slider(
                value: _level,
                min: 0,
                max: 100,
                divisions: 25,
                label: _level.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _level = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  _saveForm();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SavedDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String name = arguments['name'];
    final String surname = arguments['surname'];
    final double level = arguments['level'];
    final File? image = arguments['image'];

    return MaterialApp(
      title: 'Saved data',
      home: Scaffold(
        appBar: AppBar(title: Text('Saved Data')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 100.0,
                      backgroundImage: image != null ? FileImage(image) : null,
                      child:
                          image == null ? Icon(Icons.person, size: 50.0) : null,
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          level.toInt().toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text('Name: $name'),
              SizedBox(height: 8.0),
              Text('Surname: $surname'),
              SizedBox(height: 8.0),
              Text('Level: ${level.toInt()}'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Edit Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
