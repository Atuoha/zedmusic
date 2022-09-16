import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/circle_loader.dart';
import '../../components/kBackground.dart';
import '../../constants/colors.dart';
import '../../helper/image_picker.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/edit';

  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

enum Field { email, password, username }

class _EditProfileState extends State<EditProfile> {
  final formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var userDetails;
  final _auth = FirebaseAuth.instance;
  final _firebase = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  var isInit = true;
  var isLoading = true;
  var obscure = true;
  XFile? selectedImage;
  var updatePassword = false;

  // loading user
  _loadUser() async {
    userDetails = await _firebase.collection('users').doc(user!.uid).get();

    setState(() {
      isLoading = false;

      //assigning credentials to controllers
      emailController.text = userDetails['email'];
      usernameController.text = userDetails['username'];
    });
  }

  @override
  void initState() {
    passwordController.addListener(() {
      setState(() {});
    });
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

  _selectImage(XFile? image) {
    setState(() {
      selectedImage = image;
    });
  }

  // custom widget for all textInput
  Widget kTextField(
    String title,
    TextEditingController controller,
    Field field,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: field == Field.email
              ? TextInputType.emailAddress
              : TextInputType.text,
          autofocus: field == Field.email ? true : false,
          controller: controller,
          validator: (value) {
            switch (field) {
              case Field.password:
                if (value!.isEmpty || value.length < 8) {
                  return 'Password needs to be greater than 8 characters!';
                }
                break;

              case Field.email:
                if (value!.isEmpty) {
                  return 'Email needs to be valid!';
                }

                if (!value.contains('@')) {
                  return 'Email is not valid!';
                }
                break;

              case Field.username:
                if (value!.isEmpty || value.length < 3) {
                  return 'Username needs to be valid!';
                }
                break;
            }

            return null;
          },
          textInputAction: !updatePassword
              ? field == Field.username
                  ? TextInputAction.done
                  : TextInputAction.next
              : field == Field.password
                  ? TextInputAction.done
                  : TextInputAction.next,
          obscureText: field == Field.password ? obscure : false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 5),
            hintText: field == Field.username
                ? 'User'
                : field == Field.email
                    ? 'user@gmail.com'
                    : '********',
            suffixIcon: passwordController.text.isNotEmpty
                ? field == Field.password
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                          color: secondaryColor,
                        ),
                      )
                    : null
                : null,
            filled: true,
            fillColor: Colors.white,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: secondaryColor,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              gapPadding: 0.0,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(height: 18)
      ],
    );
  }

  // snackbar for error message
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: primaryColor,
      action: SnackBarAction(
        onPressed: () => Navigator.of(context).pop(),
        label: 'Dismiss',
        textColor: Colors.white,
      ),
    ));
  }

  // loading fnc
  isLoadingFnc() {
    setState(() {
      isLoading = true;
    });
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
    });
  }

  // submit form
  _updateProfile() async {
    var valid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    formKey.currentState!.save();
    if (!valid) {
      return;
    }

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${user!.uid}.jpg');
    File? file;
    if (selectedImage != null) {
      file = File(selectedImage!.path);
    }

    try {
      if (selectedImage != null) {
        await storageRef.putFile(file!);
      }
      // download-link of the image
      var downloadLink = await storageRef.getDownloadURL();

      // update email
      await user!.updateEmail(emailController.text.trim());

      // update password
      if (updatePassword) {
        await user!.updatePassword(passwordController.text.trim());
      }

      // update credentials on store
      _firebase.collection('users').doc(user!.uid).set({
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'auth-type': 'email',
        'image': downloadLink
      });

      // reset loading and pop out
      isLoadingFnc();
    } on FirebaseException catch (e) {
      showSnackBar('Error occurred! ${e.message}');
    } catch (e) {
      showSnackBar('Error occurred! $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      body: KBackground(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 18.0,
            left: 18.0,
            top: 60,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Ed',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white70,
                      fontSize: 24,
                    ),
                    children: [
                      TextSpan(
                        text: 'it Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(child: CircleLoading())
                    : Column(
                        children: [
                          ImageUploader(
                            selectedImage: _selectImage,
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  kTextField(
                                    'Email Address',
                                    emailController,
                                    Field.email,
                                  ),
                                  kTextField(
                                    'Username',
                                    usernameController,
                                    Field.username,
                                  ),
                                  updatePassword
                                      ? kTextField(
                                          'Password',
                                          passwordController,
                                          Field.password,
                                        )
                                      : const SizedBox.shrink(),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Text(
                                        'Update password',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Checkbox(
                                        checkColor: primaryColor,
                                        activeColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        side: const BorderSide(
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                        value: updatePassword,
                                        onChanged: (value) => setState(() {
                                          updatePassword = !updatePassword;
                                        }),
                                      ),
                                    ],
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.check_circle),
                                      style: ElevatedButton.styleFrom(
                                        primary: btnBg,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.all(15),
                                      ),
                                      label: const Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () => _updateProfile(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
