import 'package:e_tourism/shared/cubit/tour_cubit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../shared/componenet/components.dart';

class UpdateDeleteProgramScreen extends StatelessWidget {
  final String programName;
  final int programId;

  const UpdateDeleteProgramScreen({
    super.key,
    required this.programName,
    required this.programId,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: programName);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Program'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Manage Program',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            const SizedBox(height: 30),
            MyTextField(
              controller: nameController,
              hintText: 'Program Name',
              obscureText: false,
              inputType: TextInputType.text,
              prefixIcon: FontAwesomeIcons.clipboardList,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Update Program',
              icon: FontAwesomeIcons.pen,
              onPressed: () {
                TourCubit.get(context).updateProgram(context: context, programId: programId, programName: nameController.text);
              },
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
