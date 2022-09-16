import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/circle_loader.dart';
import '../constants/colors.dart';
import 'dart:io';

class ImageUploader extends StatefulWidget {
  const ImageUploader({
    Key? key,
    required this.selectedImage,
  }) : super(key: key);
  final Function(XFile) selectedImage;

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

enum Source { camera, gallery }

class _ImageUploaderState extends State<ImageUploader> {
  var userDetails;
  final _auth = FirebaseAuth.instance;
  final _firebase = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  var isInit = true;
  var isLoading = true;
  var obscure = true;
  XFile? uploadImage;
  final ImagePicker _picker = ImagePicker();

  // loading user
  _loadUser() async {
    userDetails = await _firebase.collection('users').doc(user!.uid).get();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      _loadUser();
    }
    super.didChangeDependencies();
    setState(() {
      isInit = false;
    });
  }

  Future selectImage(Source source) async {
    XFile? pickedImage;
    switch (source) {
      case Source.camera:
        pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 900,
        );
        break;

      case Source.gallery:
        pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 900,
        );
        break;
    }

    if (pickedImage == null) {
      return null;
    }
    setState(() {
      uploadImage = pickedImage;
    });
    widget.selectedImage(pickedImage);
  }

  Future avatarSource() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            'Select Avatar Source',
            style: TextStyle(
              // color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              selectImage(Source.camera);
              Navigator.of(context).pop();
            },
            label: const Text(
              'From Camera',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.camera,
              color: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              selectImage(Source.gallery);
              Navigator.of(context).pop();
            },
            label: const Text(
              'From Gallery',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.photo,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircleLoading()
        : Column(
            children: [
              uploadImage != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.file(
                            File(uploadImage!.path),
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 35,
                              color: primaryColor,
                            ),
                          ),
                        )
                      ],
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: userDetails['image'] != ''
                              ? Image.network(
                                  userDetails['image'],
                                  width: 200,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/profile.png',
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 35,
                              color: primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
            ],
          );
  }
}
