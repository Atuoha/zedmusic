import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

enum Field { username, password, phone }

class _AuthScreenState extends State<AuthScreen> {
  var isLoading = false;
  var isLogin = true;
  var obscure = true;
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
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

  // submit form
  _submitForm() {
    var valid = formKey.currentState!.validate();
    if (valid) {
      switch (isLogin) {
        case true:
          // TODO: Implement Login
          isLoadingFnc();
          break;

        case false:
          // TODO: Implement Register
          isLoadingFnc();
          break;
      }
    } else {
      return null;
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

              case Field.username:
                if (value!.isEmpty || value.length < 3) {
                  return 'Username needs to be valid!';
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
                                'Username',
                                usernameController,
                                Field.username,
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
                                    onPressed: () => setState(() {
                                      isLogin = !isLogin;
                                    }),
                                    child: KRichText(
                                      firstText: isLogin ? 'Sign' : 'Log',
                                      secondText: isLogin ? 'up' : 'in',
                                    ),
                                  ),
                                ],
                              )
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
