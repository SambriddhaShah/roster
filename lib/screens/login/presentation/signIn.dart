import 'dart:io';

import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/routes/route_generator.dart';
import 'package:rooster_empployee/routes/routes.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages/presentation/interview_stages.dart';
import 'package:rooster_empployee/screens/login/bloc/signIn_bloc.dart';
import 'package:rooster_empployee/screens/otpVerification/presentation/otpVerificationPage.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
import 'package:rooster_empployee/utils/loadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isChecked = false;
  bool _passwordVisiblity = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final _signInFormKey = GlobalKey<FormState>();
  // for single form filed validation
  final usernameKey = GlobalKey<FormFieldState>();
  final passwordKey = GlobalKey<FormFieldState>();
  // sign in sucessful message
  String? sucessfulMessage;

  // Load saved username and password
  void _loadUserNamePassword() async {
    try {
      await FlutterSecureData.getRememberMe().then((value) {
        print('the remember value is $value');
        setState(() {
          _isChecked = toBoolean(value.toString());
        });
      });
      if (await FlutterSecureData.getRememberMe() == "true") {
        username.text = await FlutterSecureData.getUserName() ?? "";
        print('the username is ${await FlutterSecureData.getUserName()}');
      }
    } catch (e) {
      print(e);
    }
  }

  // Convert a string to a boolean value
  bool toBoolean(String string) {
    if (string == 'true') {
      return true;
    } else {
      return false;
    }
  }

  // Validator function for username (email)
  String? _usernameValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Email field cannot be empty';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(val)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Validator function for password
  String? _passwordValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  @override
  void initState() {
    // _loadUserNamePassword();
    context.read<signInBloc>().add(InitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext contextt) {
    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.primary,
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<signInBloc, signInState>(
          listener: (context, state) async {
            print('the state that came is $state');
            if (state is signInError) {
              buildErrorLayout();
            } else if (state is signInInitial) {
              setState(() {
                username.text = state.username;
                _isChecked = state.isChecked;
              });
            } else if (state is signInSuccessful) {
              sucessfulMessage = state.signInmsg;
              _handelSucessfulLogin();
            }
          },
          builder: (context, state) {
            if (state is signInLoading) {
              return buildInitialInput(contextt: context, isLoading: true);
            } else if (state is signInInitial) {
              return buildInitialInput(contextt: context, isLoading: false);
            } else {
              return buildInitialInput(contextt: context, isLoading: false);
            }
          },
        ),
      ),
    );
  }

  // Widget for building the initial input form
  Widget buildInitialInput({bool? isLoading, BuildContext? contextt}) {
    return Builder(builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          isLoading == true
              ? LoadingWidget(child: Container())
              : SizedBox.shrink(),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.flutter_dash,
                        size: 100.0,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: loginForm()),
                  // ElevatedButton(onPressed: (){
                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpVerificationPage(phoneNumber: '+977-9806280992',)));
                  // }, child: Text('Press me'))
                ],
              ),
            ),
          ),
        ]),
      );
    });
  }

  // Build and display error message
  ScaffoldFeatureController buildErrorLayout() =>
      ToastMessage.showMessage('Invalid Username or Password');

  Widget loginForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign In',
            style: AppTextStyles.headline2.copyWith(color: Colors.white),
          ),
          Text(
            'Welcome Back!',
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
          SizedBox(
            height: 10.h,
          ),
          TextFormField(
            key: usernameKey,
            decoration: const InputDecoration(
                label: Text('Username'), hintText: "Enter uour username"),
            controller: username,
            validator: (val) {
              if ((val == null) ||
                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                      .hasMatch(val)) {
                return "Enter a valid email address";
              } else if (val.isEmpty) {
                return 'Email field cannot be empty';
              }
              return null;
            },
            onChanged: (value) {
              usernameKey.currentState?.validate();
            },
          ),
          SizedBox(
            height: 20.h,
          ),
          TextFormField(
            key: passwordKey,
            obscureText: _passwordVisiblity,
            decoration: InputDecoration(
                label: Text('Password'),
                hintText: "Enter password",
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisiblity = !_passwordVisiblity;
                      });
                    },
                    icon: Icon(
                      !_passwordVisiblity
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20.sp,
                    ))),
            controller: password,
            validator: (val) {
              if (val == null || (val.isEmpty)) {
                return "Password cannot be empty";
              }
              return null;
            },
            onChanged: (value) {
              passwordKey.currentState!.validate();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  Checkbox(
                      activeColor: AppColors.textPrimary,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = !_isChecked;
                          _handleRememberMe(
                              _isChecked, username.text, password.text);
                        });
                      }),
                  Text(
                    "Remember me",
                    style:
                        AppTextStyles.bodySmall.copyWith(color: Colors.white),
                  )
                ],
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style:
                        TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  ))
            ],
          ),
          ElevatedButton(
              onPressed: () {
                if (_signInFormKey.currentState!.validate()) {
                  context.read<signInBloc>().add(SignInMainEvent(
                      username: username.text.trim(), passowrd: password.text));
                } else {
                  ToastMessage.showMessage('Enter all Essential data');
                }
              },
              child: const Text(
                'Sign In',
                style: TextStyle(color: Colors.white),
              )),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(RouteGenerator()
                        .generateRoute(RouteSettings(name: Routes.signup)));
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: AppColors.textPrimary),
                  ))
            ],
          )
        ],
      ),
    );
  }

  void _handelSucessfulLogin() {
    if (username.text == "jondoe@gmail.com") {
      FlutterSecureData.setIsHired(false);
      FlutterSecureData.setIsLoggedIn('true');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InterviewDashboardPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(RouteGenerator()
          .generateRoute(const RouteSettings(name: Routes.botomNav)));
      FlutterSecureData.setIsLoggedIn('true');
    }
  }

  void _handleRememberMe(
    bool value,
    String username,
    String password,
  ) async {
    // print("${value.toString()} ====--=== $_isChecked |||| ${username.isNotEmpty} && ${password.isNotEmpty}");
    if (_isChecked || value) {
      print('the data is being set');
      // await FlutterSecureData.setUserName(username);
      // await FlutterSecureData.setPassword(password);
      await FlutterSecureData.setRememberMe(
          username.isNotEmpty && password.isNotEmpty ? true : false);
    } else {
      print('data is ont being saved and veing deleted');
      await FlutterSecureData.setRememberMe(value);
      // await FlutterSecureData.deletePassword();
    }
    //print("=-=-=-=-= ${await FlutterSecureData.getUserName()}==${await FlutterSecureData.getRememberMe()}");
  }
}
