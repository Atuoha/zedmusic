import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../components/kBackground.dart';
import '../../components/kRichtext.dart';
import '../../components/loading.dart';
import '../../constants/colors.dart';
import '../main/bottom_nav.dart';
import 'forgot_password.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum Field { email, password, phone }

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;
  var isLogin = true;
  var obscure = true;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void initState() {
    passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  // loading fnc
  isLoadingFnc() {
    setState(() {
      isLoading = true;
    });
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushNamed(BottomNav.routeName);
    });
  }


  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: primaryColor,
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

  // submit form
  _submitForm() {
    var valid = formKey.currentState!.validate();
    if (valid) {
      try {

      } on FirebaseAuthException catch (e) {
        var error = 'An error occurred. Check credentials!';
        if (e.message != null) {
          error = e.message!;
        }

        showSnackBar(error); // showSnackBar will show error if any
        setState(() {
          isLoading = false;
        });
      }


      switch (isLogin) {
        case true:
        // TODO: Implement Login
          _auth.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.trim(),
          );
          isLoadingFnc();
          break;

        case false:
        // TODO: Implement Register
          _auth.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.trim(),
          );
          isLoadingFnc();
          break;
      }
    } else {
      return null;
    }
  }

  // authenticate using Google
  _googleAuth() async{
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try{

    }on FirebaseAuthException catch (e){

    }
  }

  // custom widget for all textInput
  Widget kTextField(String title,
      TextEditingController controller,
      Field field,) {
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
          keyboardType:
          field == Field.phone ? TextInputType.phone : TextInputType.text,
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
                  return 'Username needs to be valid!';
                }

                if (!value.contains('@')) {
                  return 'Email is not valid!';
                }
                break;

              case Field.phone:
                if (value!.isEmpty || value.length < 8) {
                  return 'Phone number needs to be valid!';
                }
                break;
            }

            return null;
          },
          textInputAction: isLogin
              ? field == Field.password
              ? TextInputAction.done
              : TextInputAction.next
              : field == Field.phone
              ? TextInputAction.done
              : TextInputAction.next,
          obscureText: field == Field.password ? obscure : false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 5),
            hintText: field == Field.phone ? '+234' : null,
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
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: KBackground(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 18,
            left: 18,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/only_logo.png'),
                const SizedBox(height: 50),
                isLoading
                    ? const Loading()
                    : Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        kTextField(
                          'Email Address',
                          emailController,
                          Field.email,
                        ),
                        kTextField(
                          'Password',
                          passwordController,
                          Field.password,
                        ),
                        isLogin
                            ? const Text('')
                            : kTextField(
                          'Phone Number',
                          phoneNumberController,
                          Field.phone,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: btnBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.all(15),
                          ),
                          child: Text(
                            isLogin ? 'Log in' : 'Sign up',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () => _submitForm(),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.all(15),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google.png',
                                  width: 18,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  isLogin
                                      ? 'Log in using Google'
                                      : 'Sign up using Google',
                                  style: const TextStyle(
                                    color: googleBtn,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () => _googleAuth(),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pushNamed(
                                    ForgotPasswordScreen.routeName,
                                  ),
                              child: const KRichText(
                                firstText: 'Forgot',
                                secondText: 'Password?',
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  setState(() {
                                    isLogin = !isLogin;
                                  }),
                              child: KRichText(
                                firstText: isLogin ? 'Sign' : 'Log',
                                secondText: isLogin ? 'up' : 'in',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
