import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/componenet/components.dart';
import '../../../shared/cubit/tour_cubit.dart';

class CreateProgramScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  CreateProgramScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Program'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<TourCubit, TourState>(
          listener: (context, state) {
            // Handle loading and error states
            if (state is TourCreateProgramLoadingState) {
              // Optionally show a loading indicator
            } else if (state is TourCreateProgramSuccessfullyState) {
              // Show success message or navigate to another screen
              Navigator.pop(context); // Go back after success
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Program created successfully!')),
              );
            } else if (state is TourCreateProgramErrorState) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to create program.')),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyTextField(
                    controller: nameController,
                    hintText: 'Program Name',
                    obscureText: false,
                    inputType: TextInputType.text,
                    prefixIcon: Icons.text_fields,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: typeController,
                    hintText: 'Program Type',
                    obscureText: false,
                    inputType: TextInputType.text,
                    prefixIcon: Icons.category,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                    obscureText: false,
                    inputType: TextInputType.multiline,
                    maxLength: 200, // Optional max length
                    prefixIcon: Icons.description,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: () {
                      // Call createProgram method when button is pressed
                      context.read<TourCubit>().createProgram(
                        context: context,
                        name: nameController.text,
                        type: typeController.text,
                        description: descriptionController.text,
                      );
                    },
                    text: 'Create Program',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
