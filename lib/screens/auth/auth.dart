import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../components/kBackground.dart';
import '../../components/kRichtext.dart';
import '../../components/loading.dart';
import '../../constants/colors.dart';
import '../../providers/song.dart';
import '../main/bottom_nav.dart';
import 'forgot_password.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum Field { email, password, username }

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;
  var isLogin = true;
  var obscure = true;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  void initState() {
    passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }


  _changeAuthState(){
    setState((){
      isLogin = !isLogin;
      emailController.text = "";
      passwordController.text = "";
    });

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

  // submit form for login and registration
  _submitForm() async {
    var valid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (valid) {
      try {
        UserCredential credential;
        switch (isLogin) {
          case true:
            // TODO: Implement Login
            credential = await _auth.signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text.trim(),
            );
            isLoadingFnc();
            break;

          case false:
            // TODO: Implement Register
            credential = await _auth.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text.trim(),
            );
            // send username, email, and phone number to firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(credential.user!.uid)
                .set(
              {
                'username': usernameController.text.trim(),
                'email': emailController.text.trim(),
                'image': '',
                'auth-type': 'email',
              },
            ).then((value) {
              isLoadingFnc();
              // reset authtype
              Provider.of<SongData>(context).resetAuthType();
            });
            break;
        }
      } on FirebaseAuthException catch (e) {
        var error = 'An error occurred. Check credentials!';
        if (e.message != null) {
          if (e.code == 'user-not-found') {
            error = "Email not recognised!";
          } else if (e.code == 'account-exists-with-different-credential') {
            error = "Email already in use!";
          } else if (e.code == 'wrong-password') {
            error = 'Email or Password Incorrect!';
          } else {
            error = e.code;
          }
        }

        showSnackBar(error); // showSnackBar will show error if any
        setState(() {
          isLoading = false;
        });
      }
    } else {
      return;
    }
  }

  // authenticate using Google
  _googleAuth() async {
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

    try {
      // send username, email, and phone number to firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(googleUser!.id)
          .set(
        {
          'username': googleUser.displayName,
          'email': googleUser.email,
          'image': googleUser.photoUrl,
          'auth-type': 'google',
        },
      ).then((value) {
        isLoadingFnc();
        // update authtype
        Provider.of<SongData>(context).updateAuthType();
      });

      // sign in with credential
      return FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      var error = 'An error occurred. Check credentials!';
      if (e.message != null) {

        error = e.message!;
      }

      showSnackBar(error); // showSnackBar will show error if any
      setState(() {
        isLoading = false;
      });
    } catch(e){
      print(e);
    }
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
          autofocus: field == Field.email?true:false,
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

              case Field.username:
                if (value!.isEmpty || value.length < 3) {
                  return 'Username needs to be valid!';
                }
                break;
            }

            return null;
          },
          textInputAction: field == Field.password
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

                              // field for registration only
                              isLogin
                                  ? const SizedBox.shrink()
                                  : kTextField(
                                'Username',
                                usernameController,
                                Field.username,
                              ),

                              kTextField(
                                'Password',
                                passwordController,
                                Field.password,
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
                                    onPressed: () => _changeAuthState(),
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




/*
DOCS:
https://firebase.google.com/docs/flutter/setup?platform=android
https://firebase.google.com/docs/cli

PACKAGES:
https://pub.dev/packages/google_sign_in   OR facebook_signin for FACEBOOK
https://pub.dev/packages/firebase_core/
https://pub.dev/packages/firebase_auth/
https://pub.dev/packages/cloud_firestore

SHA FINGERPRINT
PS C:\Flutter_Apps\zedmusic\android> ./gradlew signingReport
 */



