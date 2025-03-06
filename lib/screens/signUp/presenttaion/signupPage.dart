import 'dart:convert';
import 'dart:io';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/routes/routes.dart';
import 'package:rooster_empployee/screens/otpVerification/presentation/otpVerificationPage.dart';
import 'package:rooster_empployee/screens/signUp/bloc/signup_bloc.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
import 'package:rooster_empployee/utils/loadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final firstNamekey = GlobalKey<FormFieldState>();
  final lastNamekey = GlobalKey<FormFieldState>();
  final phoneNumberkey = GlobalKey<FormFieldState>();
  final emailKey = GlobalKey<FormFieldState>();
  final locationKey = GlobalKey<FormFieldState>();
  final passwordKey = GlobalKey<FormFieldState>();
  final confirmPasswordKey = GlobalKey<FormFieldState>();

  File? _profileImage;
  String _countryCode = '+1';
  String _phoneNumber = '';
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupError) {
            ToastMessage.showMessage(state.error.message);
          } else if (state is SignupSuccessful) {
            print('the user data is ${state.userData}');
            onSuccesfullSignup(state.userData);
            // Navigator.pushReplacementNamed(context, Routes.);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OtpVerificationPage(
                      phoneNumber: '${_countryCode}${_phone.text.trim()}',
                    )));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.primary,
            appBar: AppBar(
              title: Text(
                'Sign Up',
              ),
              centerTitle: true,
            ),
            body: PopScope(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildProfileImageSection(),
                          SizedBox(height: 20.h),
                          _buildSignupForm(),
                        ],
                      ),
                    ),
                  ),
                  if (state is SignupLoading) LoadingWidget(child: Container()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50.r,
            backgroundColor: AppColors.primaryLight,
            backgroundImage:
                _profileImage != null ? FileImage(_profileImage!) : null,
            child: _profileImage == null
                ? Icon(Icons.camera_alt,
                    size: 40.r, color: AppColors.textPrimary)
                : null,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Add Profile Photo',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.surface),
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Text('Create Account',
              style: AppTextStyles.headline2.copyWith(color: Colors.white)),
          SizedBox(height: 20.h),
          _buildNameFields(firstNamekey, lastNamekey),
          SizedBox(height: 15.h),
          _buildEmailField(emailKey),
          SizedBox(height: 15.h),
          _buildPasswordField(passwordKey),
          SizedBox(height: 15.h),
          _buildConfirmPasswordField(confirmPasswordKey),
          SizedBox(height: 15.h),
          _buildPhoneField(),
          SizedBox(height: 15.h),
          _buildLocationField(locationKey),
          SizedBox(height: 20.h),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildPasswordField(GlobalKey<FormFieldState> passwordkey) {
    return TextFormField(
      key: passwordkey,
      onChanged: ((value) {
        passwordkey.currentState!.validate();
      }),
      controller: _password,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textPrimary,
            size: 20.sp,
          ),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter password';
        if (value.length < 6) return 'Minimum 6 characters';
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(GlobalKey<FormFieldState> conpasswordkey) {
    return TextFormField(
      key: conpasswordkey,
      onChanged: ((value) {
        conpasswordkey.currentState!.validate();
      }),
      controller: _confirmPassword,
      obscureText: !_confirmPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        suffixIcon: IconButton(
          icon: Icon(
            _confirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textPrimary,
            size: 20.sp,
          ),
          onPressed: () => setState(
              () => _confirmPasswordVisible = !_confirmPasswordVisible),
        ),
      ),
      validator: (value) {
        if (value != _password.text) return 'Passwords do not match';
        return null;
      },
    );
  }

  Widget _buildNameFields(GlobalKey<FormFieldState> firstnamekey,
      GlobalKey<FormFieldState> lastNamekey) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            key: firstnamekey,
            onChanged: ((value) {
              firstnamekey.currentState!.validate();
            }),
            controller: _firstName,
            decoration: const InputDecoration(labelText: 'First Name'),
            validator: (value) => value!.isEmpty ? 'Enter first name' : null,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: TextFormField(
            key: lastNamekey,
            onChanged: ((value) {
              lastNamekey.currentState!.validate();
            }),
            controller: _lastName,
            decoration: const InputDecoration(labelText: 'Last Name'),
            validator: (value) => value!.isEmpty ? 'Enter last name' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(GlobalKey<FormFieldState> itemkey) {
    return TextFormField(
      controller: _email,
      key: itemkey,
      onChanged: ((value) {
        itemkey.currentState!.validate();
      }),
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (value) =>
          !RegExp(r"^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                  .hasMatch(value!)
              ? 'Enter valid email'
              : null,
    );
  }

  Widget _buildPhoneField() {
    return IntlPhoneField(
      controller: _phone,
      initialCountryCode: _countryCode,
      onChanged: (phone) {
        setState(() {
          _countryCode = phone.countryISOCode;
          _phoneNumber = phone.number;
        });
        print('countru code : ${phone.countryCode}');
      },
      onCountryChanged: (value) {
        setState(() {
          _countryCode = value.code;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Phone Number',
      ),
    );
  }

  Widget _buildLocationField(GlobalKey<FormFieldState> itemkey) {
    return TextFormField(
      key: itemkey,
      onChanged: ((value) {
        itemkey.currentState!.validate();
      }),
      controller: _location,
      decoration: InputDecoration(
        labelText: 'Location',
        suffixIcon: IconButton(
          icon: Icon(Icons.location_on, color: AppColors.textPrimary),
          onPressed: () async {
            // Implement location picker logic
          },
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter location' : null,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50.h),
      ),
      child: Text('Register', style: AppTextStyles.button),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final SignupData = {
        'firstName': _firstName.text,
        'lastName': _lastName.text,
        'email': _email.text,
        'phone': '$_countryCode$_phoneNumber',
        'location': _location.text,
        'profileImage': _profileImage?.path,
      };

      context.read<SignupBloc>().add(
            SignupUser(
                firstName: _firstName.text.trim(),
                countyCode: _countryCode.trim(),
                lastName: _lastName.text.trim(),
                email: _email.text.trim(),
                phone: '$_countryCode ${_phone.text.trim()}',
                location: _location.text.trim(),
                photo: _profileImage?.path,
                password: _password.text.trim()),
          );
    }
  }
}

void onSuccesfullSignup(Map<String, String?> userData) {
  print('the user data in function is $userData');
  FlutterSecureData.deleteWholeSecureData().then((value) {
    FlutterSecureData.setIsLoggedIn('true');
    FlutterSecureData.setPassword(userData['password'] ?? '');
    FlutterSecureData.setUserName(userData['firstName'] ?? '');
    FlutterSecureData.setUserData(jsonEncode(userData));

    final doneTasks = [
      {
        'employeeName':
            '${userData['firstName'] ?? 'name'} ${userData['lastName'] ?? ''}',
        'employeeEmail': userData['email'] ?? 'email',
        'employeeId': 'ROO-2345',
        'taskTitle': 'Client Meeting Preparation',
        'taskDescription':
            'Prepare presentation and documents for client meeting',
        'location': 'Office Building A, Floor 12',
        'startTime': DateTime(2025, 2, 3, 20, 10).toString(),
        'endTime': DateTime(2025, 2, 3, 20, 15).toString(),
        'isLate': 'false'
      },
      {
        'employeeName':
            '${userData['firstName'] ?? 'name'} ${userData['lastName'] ?? ''}',
        'employeeEmail': userData['email'] ?? 'email',
        'employeeId': 'ROO-2345',
        'taskTitle': 'Team Strategy Discussion',
        'taskDescription':
            'Discuss strategy for upcoming project and milestones',
        'location': 'Office Building B, Conference Room 3',
        'startTime': DateTime(2025, 2, 4, 9, 30).toString(),
        'endTime': DateTime(2025, 2, 4, 10, 30).toString(),
        'isLate': 'false'
      },
      {
        'employeeName':
            '${userData['firstName'] ?? 'name'} ${userData['lastName'] ?? ''}',
        'employeeEmail': userData['email'] ?? 'email',
        'employeeId': 'ROO-2345',
        'taskTitle': 'Client Call',
        'taskDescription':
            'Call client to discuss project updates and deadlines',
        'location': 'Remote',
        'startTime': DateTime(2025, 2, 5, 15, 00).toString(),
        'endTime': DateTime(2025, 2, 5, 15, 30).toString(),
        'isLate': 'false'
      },
      {
        'employeeName':
            '${userData['firstName'] ?? 'name'} ${userData['lastName'] ?? ''}',
        'employeeEmail': userData['email'] ?? 'email',
        'employeeId': 'ROO-2345',
        'taskTitle': 'Internal Meeting',
        'taskDescription':
            'Discuss progress on internal project and team performance',
        'location': 'Office Building A, Floor 10',
        'startTime': DateTime(2025, 2, 6, 11, 00).toString(),
        'endTime': DateTime(2025, 2, 6, 12, 00).toString(),
        'isLate': 'false'
      },
      {
        'employeeName':
            '${userData['firstName'] ?? 'name'} ${userData['lastName'] ?? ''}',
        'employeeEmail': userData['email'] ?? 'email',
        'employeeId': 'ROO-2345',
        'taskTitle': 'Workshop Preparation',
        'taskDescription':
            'Prepare slides and materials for the upcoming workshop',
        'location': 'Office Building C, Training Room 5',
        'startTime': DateTime(2025, 2, 7, 8, 45).toString(),
        'endTime': DateTime(2025, 2, 7, 9, 30).toString(),
        'isLate': 'false'
      },
      {
        'employeeName':
            '${userData['firstName'] ?? 'name'} ${userData['lastName'] ?? ''}',
        'employeeEmail': userData['email'] ?? 'email',
        'employeeId': 'ROO-2345',
        'taskTitle': 'Project Review Meeting',
        'taskDescription':
            'Review project progress and set next steps with team',
        'location': 'Office Building B, Conference Room 1',
        'startTime': DateTime(2025, 2, 8, 14, 00).toString(),
        'endTime': DateTime(2025, 2, 8, 14, 45).toString(),
        'isLate': 'false'
      },
    ];

    FlutterSecureData.setDoneTask(jsonEncode(doneTasks));
    FlutterSecureData.setTodo('true');

    // FlutterSecureData.setProfileImage(image);
  });
}
