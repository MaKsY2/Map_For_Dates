import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //Future<HttpResponsePerson>...
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    }
    on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 75,),
        GestureDetector(
          onTap: () => pickImage(),
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width / 3,
            height: MediaQuery
                .of(context)
                .size
                .width / 3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              image: DecorationImage(
                image:  image != null ? FileImage(image!, scale: 5) : Image.asset('assets/emptyPhoto.png').image,
              ),
            ),
          ),
        )
      ],
    );
  }
}
