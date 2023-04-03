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

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _level = _level.roundToDouble();
      });
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
      appBar: AppBar(title: Text('Yego Form')),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _name = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Surname'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your surname';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _surname = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Level'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your level';
                  }
                  final level = int.tryParse(value);
                  if (level == null || level < 0 || level > 100) {
                    return 'Level must be between 0 and 100';
                  }
                  if (level % 4 != 0) {
                    return 'Level must be a multiple of 4';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _level = double.parse(value!);
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

    return Scaffold(
      appBar: AppBar(title: Text('Saved Data')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.0,
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
    );
  }
}

