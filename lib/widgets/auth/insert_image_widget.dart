import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InsertImageWidget extends StatefulWidget {
   InsertImageWidget({required this.selectImage,super.key});

  Function selectImage;

  @override
  State<InsertImageWidget> createState() => _InsertImageWidgetState();

}
class _InsertImageWidgetState extends State<InsertImageWidget> {
  File? _storedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         CircleAvatar(
          radius: 40,
          backgroundImage: _storedImage != null ? FileImage(_storedImage!) : null,
        ),
        const SizedBox(
          height: 8,
        ),
        TextButton.icon(
          onPressed: () {
            pickImage();
          },
          icon: const Icon(Icons.image),

          label: const Text('add image'),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  void pickImage() async {
    final picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 100);
    if(image?.path !=null) {
      final imageFile = File(image!.path);
      setState(() {
        _storedImage = imageFile;
        widget.selectImage(imageFile);
      });
  }
}
}