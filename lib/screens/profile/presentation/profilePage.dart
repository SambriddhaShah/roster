

import 'dart:io';

import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/profile/bloc/profile_bloc.dart';
import 'package:rooster_empployee/utils/loadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

class ProfilePage extends StatefulWidget {
  final String userRole;
  const ProfilePage({super.key, required this.userRole});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  late Map<String, dynamic> _userData;
  File? _profileImage;

  // Profile Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();

  // Password Change Controllers
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  // Form Keys
  final GlobalKey<FormFieldState> _firstNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _lastNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _companyKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _registrationKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _oldPasswordKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _newPasswordKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _confirmPasswordKey =
      GlobalKey<FormFieldState>();

  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(InitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        // automaticallyImplyLeading: false,
        // actions: [IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back))],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ToastMessage.showMessage(state.error.message);
          } else if (state is ProfileSuccessful) {
            setState(() {
              print('the userData is ${state.userData}');
              _userData = state.userData;
              _initializeProfileControllers(_userData);
            });
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return LoadingWidget(child: InitialLayout(false));
          } else if (state is ProfileSuccessful) {
            return buildLayout(state.userData);
          } else if (state is ProfileError) {
            return InitialLayout(true);
          }
          return LoadingWidget(child: InitialLayout(false));
        },
      ),
    );
  }

  Widget InitialLayout(bool isError) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          isError ? 'Error Occurred' : 'No Data To Show',
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }

  Widget buildLayout(Map<String, dynamic> _userData) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Profile Update Section
          Form(
            key: _profileFormKey,
            child: Column(
              children: [
                _buildProfileImageSection(_userData),
                SizedBox(height: 20.h),
                if (widget.userRole == 'user') ...[
                  _buildNameFields(_userData),
                  SizedBox(height: 15.h),
                  _buildCompanyFields(_userData),
                  SizedBox(height: 15.h),
                ],
                _buildEmailField(_userData),
                SizedBox(height: 20.h),
                _buildProfileUpdateButton(),
              ],
            ),
          ),

          // Password Change Section
          Container(
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Form(
              key: _passwordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change Password',
                    style: AppTextStyles.headline3,
                  ),
                  SizedBox(height: 15.h),
                  _buildOldPasswordField(),
                  SizedBox(height: 15.h),
                  _buildNewPasswordFields(),
                  SizedBox(height: 20.h),
                  _buildPasswordChangeButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection(Map<String, dynamic> _userData) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50.r,
            backgroundColor: AppColors.primary.withOpacity(0.3),
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : (_userData['profileImage'] != null
                    ? FileImage(File(_userData['profileImage']))
                    : AssetImage('assets/defaultprofileimage.png')),
            child: _profileImage == null && _userData['profileImage'] == null
                ? Icon(Icons.camera_alt,
                    size: 40.r, color: AppColors.textPrimary)
                : null,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Update Profile Photo',
          style:
              AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildNameFields(Map<String, dynamic> _userData) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            key: _firstNameKey,
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
            validator: (value) => value!.isEmpty ? 'Enter first name' : null,
            onChanged: (value) => _firstNameKey.currentState!.validate(),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: TextFormField(
            key: _lastNameKey,
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
            validator: (value) => value!.isEmpty ? 'Enter last name' : null,
            onChanged: (value) => _lastNameKey.currentState!.validate(),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyFields(Map<String, dynamic> _userData) {
    return Column(
      children: [
        TextFormField(
          key: _companyKey,
          controller: _companyNameController,
          decoration: const InputDecoration(labelText: 'Company Name'),
          validator: (value) => value!.isEmpty ? 'Enter company name' : null,
          onChanged: (value) => _companyKey.currentState!.validate(),
        ),
        SizedBox(height: 15.h),
        TextFormField(
          key: _registrationKey,
          controller: _registrationController,
          decoration: const InputDecoration(labelText: 'Registration Details'),
          validator: (value) =>
              value!.isEmpty ? 'Enter registration details' : null,
          onChanged: (value) => _registrationKey.currentState!.validate(),
        ),
      ],
    );
  }

  Widget _buildEmailField(Map<String, dynamic> _userData) {
    return TextFormField(
      key: _emailKey,
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (value) =>
          !RegExp(r"^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                  .hasMatch(value!)
              ? 'Enter valid email'
              : null,
      onChanged: (value) => _emailKey.currentState!.validate(),
    );
  }

  Widget _buildOldPasswordField() {
    return TextFormField(
      key: _oldPasswordKey,
      controller: _oldPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Old Password',
        border: OutlineInputBorder(),
      ),
      onChanged: ((value) {
        _oldPasswordKey.currentState!.validate();
      }),
      validator: (value) => value!.isEmpty ? 'Enter old password' : null,
    );
  }

  Widget _buildNewPasswordFields() {
    return Column(
      children: [
        TextFormField(
          key: _newPasswordKey,
          controller: _newPasswordController,
          obscureText: !_newPasswordVisible,
          decoration: InputDecoration(
            labelText: 'New Password',
            suffixIcon: IconButton(
              icon: Icon(
                _newPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textPrimary,
              ),
              onPressed: () =>
                  setState(() => _newPasswordVisible = !_newPasswordVisible),
            ),
            border: OutlineInputBorder(),
          ),
          onChanged: ((value) {
            _newPasswordKey.currentState!.validate();
          }),
          validator: (value) {
            if (value!.isEmpty) return 'Enter new password';
            if (value.length < 6) return 'Minimum 6 characters';
            return null;
          },
        ),
        SizedBox(height: 15.h),
        TextFormField(
          key: _confirmPasswordKey,
          controller: _confirmNewPasswordController,
          obscureText: !_confirmPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Confirm New Password',
            suffixIcon: IconButton(
              icon: Icon(
                _confirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.textPrimary,
              ),
              onPressed: () => setState(
                  () => _confirmPasswordVisible = !_confirmPasswordVisible),
            ),
            border: OutlineInputBorder(),
          ),
          onChanged: ((value) {
            _confirmPasswordKey.currentState!.validate();
          }),
          validator: (value) {
            if (value != _newPasswordController.text)
              return 'Passwords do not match';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildProfileUpdateButton() {
    return ElevatedButton(
      onPressed: _submitProfileUpdate,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50.h),
      ),
      child: Text('Update Profile', style: AppTextStyles.button),
    );
  }

  Widget _buildPasswordChangeButton() {
    return ElevatedButton(
      onPressed: _submitPasswordChange,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50.h),
      ),
      child: Text('Change Password', style: AppTextStyles.button),
    );
  }

  void _submitProfileUpdate() {
    if (_profileFormKey.currentState!.validate()) {
      final updatedData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'companyName': _companyNameController.text,
        'registrationDetails': _registrationController.text,
        'profileImage': _profileImage?.path ?? _userData['profileImage'],
      };

      context.read<ProfileBloc>().add(UpdateProfileEvent(updatedData));
    }
  }

  void _submitPasswordChange() {
    if (_passwordFormKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(ChangePasswordEvent(
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
            confirmPassword: _confirmNewPasswordController.text,
          ));
    }
  }

  void _initializeProfileControllers(Map<String, dynamic> _userData) {
    _firstNameController.text = _userData['firstName'] ?? '';
    _lastNameController.text = _userData['lastName'] ?? '';
    _emailController.text = _userData['email'] ?? '';
    _companyNameController.text = _userData['companyName'] ?? '';
    _registrationController.text = _userData['registrationDetails'] ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _companyNameController.dispose();
    _registrationController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
