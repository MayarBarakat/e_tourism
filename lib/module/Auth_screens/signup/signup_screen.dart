import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';

import '../../../shared/componenet/components.dart';
import '../../../shared/cubit/tour_cubit.dart'; // Ensure this is imported

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TourCubit, TourState>(
      listener: (context, state) {
        // Handle signup states like success or error here.
      },
      builder: (context, state) {
        var cubit = TourCubit.get(context);

        return BlurryModalProgressHUD(
          inAsyncCall: cubit.loadingSignup, // Show loading spinner while signup is processing
          blurEffectIntensity: 4,
          progressIndicator: const SpinKitFadingCircle(
            color: Color(0xFF577D86),
            size: 90.0,
          ),
          dismissible: false,
          opacity: 0.4,
          color: Colors.black.withOpacity(0.1),
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        Icon(
                          Icons.person_add,
                          size: 100,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 50),
                        Text(
                          "Create Your Account",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 25),
                        MyTextField(
                          controller: firstNameController,
                          hintText: "First Name",
                          obscureText: false,
                          inputType: TextInputType.text,
                          prefixIcon: Icons.person,
                          validator: RequiredValidator(
                            errorText: 'First name is required',
                          ),
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: lastNameController,
                          hintText: "Last Name",
                          obscureText: false,
                          inputType: TextInputType.text,
                          prefixIcon: Icons.person_outline,
                          validator: RequiredValidator(
                            errorText: 'Last name is required',
                          ),
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: emailController,
                          hintText: "Email",
                          obscureText: false,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Email is required'),
                            EmailValidator(errorText: 'Enter a valid email address'),
                          ]).call,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: passwordController,
                          hintText: "Password",
                          obscureText: true,
                          inputType: TextInputType.text,
                          prefixIcon: Icons.lock,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Password is required'),
                            MinLengthValidator(6, errorText: 'Minimum 6 characters required'),
                          ]).call,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: descriptionController,
                          hintText: "Description",
                          obscureText: false,
                          inputType: TextInputType.text,
                          prefixIcon: Icons.description,
                          maxLength: 150,
                          validator: RequiredValidator(
                            errorText: 'Description is required',
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: MyButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                cubit.signup(
                                  context: context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  description: descriptionController.text,
                                );
                              }
                            },
                            text: "Sign Up",
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Powered By Team",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              child: TextButton(
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context); // Navigate back to login
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
