import 'package:flutter/material.dart';
import 'DetectButton.dart';
import 'GalleryButton.dart';
import 'dart:io';
import 'ImageDisplay.dart';
import 'package:image_picker/image_picker.dart';
import 'ResultScreen.dart';
import 'ModelHandler.dart';

class myhome extends StatefulWidget {
  const myhome({super.key});

  @override
  State<myhome> createState() => _myhomeState();
}

class _myhomeState extends State<myhome> {
  File? image;
  late ModelHandler modelHandler;
  String? _predictedTitle;
  late String? _result;

  @override
  void initState() {
    super.initState();
    modelHandler = ModelHandler();
    modelHandler.loadModel();
  }

  String getDescriptionFromTitle(String? title) {
    switch (title) {
      case 'YES':
        return 'Tumor is detected.A brain tumor is a growth of cells in the brain or near it. Brain tumors can happen in the brain tissue. Brain tumors also can happen near the brain tissue. Nearby locations include nerves, the pituitary gland, the pineal gland, and the membranes that cover the surface of the brain.';
      default:
        return 'A brain tumor is a growth of cells in the brain or near it. Brain tumors can happen in the brain tissue. Brain tumors also can happen near the brain tissue. Nearby locations include nerves, the pituitary gland, the pineal gland, and the membranes that cover the surface of the brain.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3A3A3A),
        centerTitle: true,
        title: const Text(
          'BRAIN TUMOR',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            wordSpacing: 1.5,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 1,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SafeArea(
              minimum: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
            Align(
              alignment: Alignment.center,
              heightFactor: 5,
              child: GalleryButton(
                onPressed: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      image = File(pickedFile.path);
                    });
                  }
                },
              ),
            ),
            Container(
              height: 200,
              width: 250,
              color: const Color(0xFF757575),
              child: ImageDisplay(image: image),
            ),
            SafeArea(
              minimum: const EdgeInsets.only(top: 90),
              child: Align(
                alignment: Alignment.center,
                child: DetectButton(
                  onPressed: () async {
                    if (image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.red),
                              SizedBox(width: 10),
                              Text('Please upload an image'),
                            ],
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      try {
                        _predictedTitle = await modelHandler.predict(image!); // Remove unnecessary type casting
                        setState(() {
                          _result = _predictedTitle; // Update the value of the _result variable
                        });
                        String displayTitle = _predictedTitle ?? "No prediction available";
                        String description = getDescriptionFromTitle(_predictedTitle);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => myResultScreen(
                              title: displayTitle,
                              description: description,
                              image: image,
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  image: image,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
