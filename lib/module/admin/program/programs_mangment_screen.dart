import 'package:e_tourism/module/admin/program/create_program_screen.dart';
import 'package:e_tourism/module/admin/program/edit_program_screen.dart';
import 'package:e_tourism/shared/componenet/components.dart';
import 'package:e_tourism/shared/cubit/tour_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ProgramsManagementScreen extends StatelessWidget {
  const ProgramsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TourCubit, TourState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs Management'),
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
              'Manage Programs',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            const SizedBox(height: 30),
            _buildActionButton(
              context,
              title: 'Create Program',
              color: Colors.teal.shade400,
              icon: FontAwesomeIcons.plus,
              onTap: () {
                navigateTo(context, CreateProgramScreen());
              },
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 30),
            Expanded(
              child: _buildProgramsList(context), // Function to list all programs
            ),
          ],
        ),
      ),
    );
  },
);
  }

  Widget _buildActionButton(BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      icon: FaIcon(icon, size: 20, color: Colors.white),
      label: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildProgramsList(BuildContext context) {
    // الحصول على البرامج من الـ TourCubit
    var cubit = TourCubit.get(context);
    final programs = cubit.allProgramsModel.data;

    if (programs == null || programs.isEmpty) {
      // عرض رسالة إذا كانت القائمة فارغة
      return const Center(
        child: Text(
          'No programs available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      itemCount: programs.length,
      itemBuilder: (context, index) {
        final program = programs[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.clipboardList, color: Colors.teal),
            title: Text(
              program.name!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'ID: ${program.id}', // عرض معرف البرنامج
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.pen, color: Colors.blue),
                  onPressed: () {
                    // الذهاب إلى شاشة التعديل
                    navigateTo(context, UpdateDeleteProgramScreen(
                      programName: program.name!,
                      programId: program.id!,
                    ));
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.trash, color: Colors.red),
                  onPressed: () {
                    cubit.deleteProgram(context: context, programId: program.id!, programName: program.name!);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
