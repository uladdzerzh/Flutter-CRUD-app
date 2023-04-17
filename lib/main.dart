import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yego Form',
      initialRoute: '/',
      routes: {
        '/': (context) => const YegoForm(),
        '/saved_data': (context) => SavedDataScreen(),
      },
    );
  }
}

class YegoForm extends StatefulWidget {
  const YegoForm({super.key});

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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
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
    } else {
      _formKey.currentState!.validate();
      _showSnackBar(context, 'Please correct the errors in the form');
    }
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yego Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                          ? const Icon(Icons.person, size: 50.0)
                          : null,
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          _level.toInt().toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: _validateName,
                onSaved: (value) {
                  setState(() {
                    _name = value!;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Surname'),
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
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  _saveForm();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SavedDataScreen extends StatelessWidget {
  const SavedDataScreen({super.key});

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
        appBar: AppBar(title: const Text('Saved Data')),
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
                      child: image == null
                          ? const Icon(Icons.person, size: 50.0)
                          : null,
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          level.toInt().toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Text('Name: $name'),
              const SizedBox(height: 8.0),
              Text('Surname: $surname'),
              const SizedBox(height: 8.0),
              Text('Level: ${level.toInt()}'),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Edit Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
