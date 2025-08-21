// import 'dart:io';

// import 'package:rooster_empployee/constants/appColors.dart';
// import 'package:rooster_empployee/constants/appTextStyles.dart';
// import 'package:rooster_empployee/routes/route_generator.dart';
// import 'package:rooster_empployee/routes/routes.dart';
// import 'package:rooster_empployee/screens/Applicant/Interview%20Stages/presentation/interview_stages.dart';
// import 'package:rooster_empployee/screens/login/bloc/signIn_bloc.dart';
// import 'package:rooster_empployee/screens/otpVerification/presentation/otpVerificationPage.dart';
// import 'package:rooster_empployee/service/flutterSecureData.dart';
// import 'package:rooster_empployee/utils/loadingScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:rooster_empployee/utils/tostMessage.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool _isChecked = false;
//   bool _passwordVisiblity = false;
//   TextEditingController username = TextEditingController();
//   TextEditingController password = TextEditingController();
//   final _signInFormKey = GlobalKey<FormState>();
//   // for single form filed validation
//   final usernameKey = GlobalKey<FormFieldState>();
//   final passwordKey = GlobalKey<FormFieldState>();
//   // sign in sucessful message
//   String? sucessfulMessage;

//   // Load saved username and password
//   // void _loadUserNamePassword() async {
//   //   try {
//   //     await FlutterSecureData.getRememberMe().then((value) {
//   //       print('the remember value is $value');
//   //       setState(() {
//   //         _isChecked = toBoolean(value.toString());
//   //       });
//   //     });
//   //     if (await FlutterSecureData.getRememberMe() == "true") {
//   //       final usernameData = await FlutterSecureData.getUserName() ?? "";
//   //       setState(() {
//   //         username.text = usernameData;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }

//   // Convert a string to a boolean value
//   bool toBoolean(String string) {
//     if (string == 'true') {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   // Validator function for username (email)
//   String? _usernameValidator(String? val) {
//     if (val == null || val.isEmpty) {
//       return 'Email field cannot be empty';
//     } else if (!RegExp(
//             r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
//         .hasMatch(val)) {
//       return 'Enter a valid email address';
//     }
//     return null;
//   }

//   // Validator function for password
//   String? _passwordValidator(String? val) {
//     if (val == null || val.isEmpty) {
//       return 'Password cannot be empty';
//     }
//     return null;
//   }

//   @override
//   void initState() {
//     // _loadUserNamePassword();
//     context.read<signInBloc>().add(InitialEvent());
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext contextt) {
//     return PopScope(
//       // ignore: deprecated_member_use
//       onPopInvoked: (didPop) {
//         if (Platform.isAndroid) {
//           SystemNavigator.pop();
//         } else if (Platform.isIOS) {
//           exit(0);
//         }
//       },

//       child: Scaffold(
//         backgroundColor: AppColors.primary,
//         resizeToAvoidBottomInset: false,
//         body: BlocConsumer<signInBloc, signInState>(
//           listener: (context, state) async {
//             print('the state that came is $state');
//             if (state is signInError) {
//               buildErrorLayout(state.error.message);
//             } else if (state is signInInitial) {
//               setState(() {
//                 username.text = state.username;
//                 _isChecked = state.isChecked;
//               });
//             } else if (state is signInSuccessful) {
//               sucessfulMessage = state.signInmsg;
//               _handelSucessfulLogin();
//             }
//           },
//           builder: (context, state) {
//             return SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Stack(children: [
//                 SingleChildScrollView(
//                   child: Container(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.12,
//                         ),
//                         const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.flutter_dash,
//                               size: 100.0,
//                               color: AppColors.textPrimary,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20.h,
//                         ),
//                         Container(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 15.h, horizontal: 10.w),
//                             decoration: BoxDecoration(
//                               color: AppColors.primaryLight,
//                               borderRadius: BorderRadius.circular(20.r),
//                             ),
//                             width: MediaQuery.of(context).size.width,
//                             child: loginForm()),
//                         // ElevatedButton(onPressed: (){
//                         //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpVerificationPage(phoneNumber: '+977-9806280992',)));
//                         // }, child: Text('Press me'))
//                       ],
//                     ),
//                   ),
//                 ),
//                 if (state is signInLoading) ...[
//                   LoadingWidget(child: Container())
//                 ],
//               ]),
//             );

//             // if (state is signInLoading) {
//             //   print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
//             //   return buildInitialInput(contextt: context, isLoading: true);
//             // } else if (state is signInInitial) {
//             //   return buildInitialInput(contextt: context, isLoading: false);
//             // } else {
//             //   return buildInitialInput(contextt: context, isLoading: false);
//             // }
//           },
//         ),
//       ),
//     );
//   }

//   // Widget for building the initial input form
//   Widget buildInitialInput({bool? isLoading, BuildContext? contextt}) {
//     return Builder(builder: (BuildContext context) {
//       return SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Stack(children: [
//           isLoading == true
//               ? LoadingWidget(child: Container())
//               : SizedBox.shrink(),
//           SingleChildScrollView(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.12,
//                   ),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.flutter_dash,
//                         size: 100.0,
//                         color: AppColors.textPrimary,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20.h,
//                   ),
//                   Container(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 15.h, horizontal: 10.w),
//                       decoration: BoxDecoration(
//                         color: AppColors.primaryLight,
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                       width: MediaQuery.of(context).size.width,
//                       child: loginForm()),
//                   // ElevatedButton(onPressed: (){
//                   //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpVerificationPage(phoneNumber: '+977-9806280992',)));
//                   // }, child: Text('Press me'))
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       );
//     });
//   }

//   // Build and display error message
//   ScaffoldFeatureController buildErrorLayout(String mesage) =>
//       ToastMessage.showMessage(mesage);

//   Widget loginForm() {
//     return Form(
//       key: _signInFormKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Sign In',
//             style: AppTextStyles.headline2.copyWith(color: Colors.white),
//           ),
//           Text(
//             'Welcome Back!',
//             style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
//           ),
//           SizedBox(
//             height: 10.h,
//           ),
//           TextFormField(
//             key: usernameKey,
//             decoration: const InputDecoration(
//                 label: Text('Username'), hintText: "Enter your username"),
//             controller: username,
//             validator: (val) {
//               if ((val == null) ||
//                   !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
//                       .hasMatch(val)) {
//                 return "Enter a valid email address";
//               } else if (val.isEmpty) {
//                 return 'Email field cannot be empty';
//               }
//               return null;
//             },
//             onChanged: (value) {
//               usernameKey.currentState?.validate();
//             },
//           ),
//           SizedBox(
//             height: 20.h,
//           ),
//           TextFormField(
//             key: passwordKey,
//             obscureText: _passwordVisiblity,
//             decoration: InputDecoration(
//                 label: Text('Password'),
//                 hintText: "Enter password",
//                 suffixIcon: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _passwordVisiblity = !_passwordVisiblity;
//                       });
//                     },
//                     icon: Icon(
//                       !_passwordVisiblity
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       size: 20.sp,
//                     ))),
//             controller: password,
//             validator: (val) {
//               if (val == null || (val.isEmpty)) {
//                 return "Password cannot be empty";
//               }
//               return null;
//             },
//             onChanged: (value) {
//               passwordKey.currentState!.validate();
//             },
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: <Widget>[
//                   Checkbox(
//                       activeColor: AppColors.textPrimary,
//                       shape: ContinuousRectangleBorder(
//                           borderRadius: BorderRadius.circular(7)),
//                       value: _isChecked,
//                       onChanged: (value) {
//                         setState(() {
//                           _isChecked = !_isChecked;
//                           _handleRememberMe(
//                               _isChecked, username.text, password.text);
//                         });
//                       }),
//                       ///Users/omegabpo/Projects/ReactNative/rooster_empployee/build/app/outputs/flutter-apk/app-release.apk
//                   Text(
//                     "Remember me",
//                     style:
//                         AppTextStyles.bodySmall.copyWith(color: Colors.white),
//                   )
//                 ],
//               ),
//               // TextButton(
//               //     onPressed: () {},
//               //     child: const Text(
//               //       'Forgot Password?',
//               //       style:
//               //           TextStyle(color: AppColors.textPrimary, fontSize: 14),
//               //     ))
//             ],
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 if (_signInFormKey.currentState!.validate()) {
//                   context.read<signInBloc>().add(SignInMainEvent(
//                       username: username.text.trim(), passowrd: password.text));
//                 } else {
//                   ToastMessage.showMessage('Enter all Essential data');
//                 }
//               },
//               child: const Text(
//                 'Sign In',
//                 style: TextStyle(color: Colors.white),
//               )),
//           // SizedBox(
//           //   height: 20.h,
//           // ),
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   children: [
//           //     Text(
//           //       "Don't have an account?",
//           //       style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
//           //     ),
//           //     TextButton(
//           //         onPressed: () {
//           //           Navigator.of(context).push(RouteGenerator()
//           //               .generateRoute(RouteSettings(name: Routes.signup)));
//           //         },
//           //         child: const Text(
//           //           'Sign Up',
//           //           style: TextStyle(color: AppColors.textPrimary),
//           //         ))
//           //   ],
//           // )
//         ],
//       ),
//     );
//   }

//   void _handelSucessfulLogin() {
//     // if (username.text == "jondoe@gmail.com") {

//     FlutterSecureData.setIsLoggedIn('true');
//     // Navigator.pushReplacement(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => InterviewDashboardPage()),
//     // );
//     Navigator.of(context).pushReplacement(RouteGenerator()
//         .generateRoute(const RouteSettings(name: Routes.applicantMainPage)));
//     //   } else {
//     //     Navigator.of(context).pushReplacement(RouteGenerator()
//     //         .generateRoute(const RouteSettings(name: Routes.botomNav)));
//     //     FlutterSecureData.setIsLoggedIn('true');
//     //   }
//   }

//   void _handleRememberMe(
//     bool value,
//     String username,
//     String password,
//   ) async {
//     // print("${value.toString()} ====--=== $_isChecked |||| ${username.isNotEmpty} && ${password.isNotEmpty}");
//     if (_isChecked || value) {
//       print('the data is being set');
//       // await FlutterSecureData.setUserName(username);
//       // await FlutterSecureData.setPassword(password);
//       await FlutterSecureData.setRememberMe(
//           username.isNotEmpty && password.isNotEmpty ? true : false);
//     } else {
//       print('data is ont being saved and veing deleted');
//       await FlutterSecureData.setRememberMe(value);
//       // await FlutterSecureData.deletePassword();
//     }
//     //print("=-=-=-=-= ${await FlutterSecureData.getUserName()}==${await FlutterSecureData.getRememberMe()}");
//   }
// }
//rigew24840@gardsiir.com 4Ta6nis71ha

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/routes/route_generator.dart';
import 'package:rooster_empployee/routes/routes.dart';
import 'package:rooster_empployee/screens/login/bloc/signIn_bloc.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
import 'package:rooster_empployee/utils/loadingScreen.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isChecked = false;
  bool _passwordVisibility = false;
  final _signInFormKey = GlobalKey<FormState>();
  final usernameKey = GlobalKey<FormFieldState>();
  final passwordKey = GlobalKey<FormFieldState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  String? successfulMessage;

  @override
  void initState() {
    context.read<signInBloc>().add(InitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<signInBloc, signInState>(
          listener: (context, state) async {
            if (state is signInError) {
              ToastMessage.showMessage(state.error.message);
            } else if (state is signInInitial) {
              setState(() {
                username.text = state.username;
                _isChecked = state.isChecked;
              });
            } else if (state is signInSuccessful) {
              successfulMessage = state.signInmsg;
              _handleSuccessfulLogin();
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        // Big "Welcome back!"
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Welcome\n",
                                style: AppTextStyles.display
                                    .copyWith(color: AppColors.primary)),
                            TextSpan(
                                text: "back!", style: AppTextStyles.display),
                          ]),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Sign in to access your candiate account and get real-time updates on your application status.",
                          style: AppTextStyles.bodySmall,
                        ),
                        SizedBox(height: 28.h),

                        // Card container for the form (subtle shadow)
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              )
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 20.h),
                          child: Form(
                            key: _signInFormKey,
                            child: Column(
                              children: [
                                // Email
                                TextFormField(
                                  key: usernameKey,
                                  controller: username,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.mail_outline),
                                    hintText: "Enter your mail/phone number",
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Email field cannot be empty';
                                    }
                                    final ok = RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
                                    ).hasMatch(val);
                                    if (!ok)
                                      return 'Enter a valid email address';
                                    return null;
                                  },
                                  onChanged: (_) =>
                                      usernameKey.currentState?.validate(),
                                ),
                                SizedBox(height: 14.h),

                                // Password
                                TextFormField(
                                  key: passwordKey,
                                  controller: password,
                                  obscureText: !_passwordVisibility,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    hintText: "Enter your password",
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() =>
                                          _passwordVisibility =
                                              !_passwordVisibility),
                                      icon: Icon(_passwordVisibility
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  ),
                                  validator: (val) =>
                                      (val == null || val.isEmpty)
                                          ? 'Password cannot be empty'
                                          : null,
                                  onChanged: (_) =>
                                      passwordKey.currentState?.validate(),
                                ),
                                SizedBox(height: 10.h),

                                // Remember + Forgot
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isChecked,
                                      onChanged: (v) {
                                        setState(() {
                                          _isChecked = v ?? false;
                                          _handleRememberMe(_isChecked,
                                              username.text, password.text);
                                        });
                                      },
                                    ),
                                    Text("Remember me",
                                        style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textPrimary)),
                                    // const Spacer(),
                                    // TextButton(
                                    //   onPressed: () {
                                    //     // TODO: navigate to ForgotPassword if exists
                                    //   },
                                    //   child: const Text("Forgot password"),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 10.h),

                                // CTA
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_signInFormKey.currentState!
                                          .validate()) {
                                        context
                                            .read<signInBloc>()
                                            .add(SignInMainEvent(
                                              username: username.text.trim(),
                                              passowrd: password.text,
                                            ));
                                      } else {
                                        ToastMessage.showMessage(
                                            'Enter all essential data');
                                      }
                                    },
                                    child: const Text('Sign in'),
                                  ),
                                ),

                                // Or divider
                                // SizedBox(height: 16.h),
                                // Row(
                                //   children: [
                                //     const Expanded(child: Divider()),
                                //     Padding(
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 12),
                                //       child: Text("Or",
                                //           style: AppTextStyles.bodySmall),
                                //     ),
                                //     const Expanded(child: Divider()),
                                //   ],
                                // ),
                                // SizedBox(height: 16.h),

                                // // Google button (outlined, white)
                                // SizedBox(
                                //   width: double.infinity,
                                //   child: OutlinedButton.icon(
                                //     onPressed: () {
                                //       // TODO: trigger Google sign-in
                                //     },
                                //     style: OutlinedButton.styleFrom(
                                //       backgroundColor: AppColors.surface,
                                //       side: const BorderSide(
                                //           color: AppColors.border),
                                //       minimumSize: const Size.fromHeight(56),
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(28)),
                                //       textStyle: GoogleFonts.inter(
                                //           fontSize: 16,
                                //           fontWeight: FontWeight.w600),
                                //     ),
                                //     icon: Image.asset('assets/google.png',
                                //         width: 20,
                                //         height: 20,
                                //         errorBuilder: (_, __, ___) =>
                                //             const Icon(Icons.g_mobiledata)),
                                //     label: const Text("Continue with Google"),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom: create account
                        // SizedBox(height: 20.h),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text("Don't have an account? ",
                        //         style: AppTextStyles.bodySmall),
                        //     TextButton(
                        //       onPressed: () {
                        //         Navigator.of(context).push(
                        //           RouteGenerator().generateRoute(
                        //               const RouteSettings(name: Routes.signup)),
                        //         );
                        //       },
                        //       child: const Text("Create an account"),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),
                if (state is signInLoading) LoadingWidget(child: Container()),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleSuccessfulLogin() {
    FlutterSecureData.setIsLoggedIn('true');
    Navigator.of(context).pushReplacement(
      RouteGenerator()
          .generateRoute(const RouteSettings(name: Routes.applicantMainPage)),
    );
  }

  void _handleRememberMe(bool value, String user, String pass) async {
    await FlutterSecureData.setRememberMe(
        user.isNotEmpty && pass.isNotEmpty ? value : false);
  }
}
