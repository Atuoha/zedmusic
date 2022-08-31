import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zedmusic/screens/auth/auth.dart';
import '../../components/kBackground.dart';
import '../../components/kRichtext.dart';
import '../../components/loading.dart';
import '../../constants/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot';

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  var isLoading = false;

  // loading fnc
  isLoadingFnc() {
    setState(() {
      isLoading = true;
    });
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushNamed('');
    });
  }

  // submit form
  _submitForm() {
    var valid = formKey.currentState!.validate();
    if (valid) {
      // TODO: Implement Forgot password

    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
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
      body:KBackground(
        fade: true,
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
                              Column(
                                children: [
                                  const Text(
                                    'Phone Number',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: phoneNumberController,
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 8) {
                                        return 'Phone needs to be valid';
                                      }

                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(left: 5),
                                      hintText: '+234',
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
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: btnBg,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                ),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () => _submitForm(),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(AuthScreen.routeName);
                                },
                                child: const KRichText(
                                  firstText: 'Remembered',
                                  secondText: 'Password?',
                                ),
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
