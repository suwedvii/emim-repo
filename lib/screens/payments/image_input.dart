import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? selectedImage;

  void _openImagePicker(String mode) async {
    final imagePicker = ImagePicker();

    XFile? pickedImage;

    if (mode == 'gallery') {
      pickedImage = await imagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 600);
    } else {
      pickedImage = await imagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 600);
    }

    if (pickedImage == null) {
      return;
    }

    setState(() {
      selectedImage = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined),
              SizedBox(
                width: 6,
              ),
              Text('Take a photo'),
            ],
          ),
          onTap: () {
            _openImagePicker('camera');
          },
        ),
        const SizedBox(
          height: 8,
        ),
        GestureDetector(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_open_rounded),
              SizedBox(
                width: 6,
              ),
              Text('Choose from gallery'),
            ],
          ),
          onTap: () {
            _openImagePicker('gallery');
          },
        ),
      ],
    );

    if (selectedImage != null) {
      content = Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    return Container(
        width: double.infinity,
        height: 500,
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withOpacity(0.5),
              width: 1),
        ),
        child: content);
  }
}
