import 'package:e_tourism/module/programs/program_details.dart';
import 'package:e_tourism/shared/componenet/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_tourism/shared/cubit/tour_cubit.dart';

import '../../models/programs_models/all_programs_model.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TourCubit>().getAllPrograms(context: context);
    return BlocConsumer<TourCubit, TourState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TourCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('Programs', style: TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: cubit.loadingAllPrograms
              ? Center(child: CircularProgressIndicator())
              : cubit.allProgramsModel != null && cubit.allProgramsModel.data != null && cubit.allProgramsModel.data!.isNotEmpty
              ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: cubit.allProgramsModel.data!.length,
            itemBuilder: (context, index) {
              var program = cubit.allProgramsModel.data![index];
              return ProgramCard(program: program);
            },
          )
              : Center(
            child: Text(
              'No programs available.',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
          ),
        );
      },
    );
  }
}

class ProgramCard extends StatelessWidget {
  final Data program;

  const ProgramCard({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Theme.of(context).primaryColor.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section with an icon or badge
              Row(
                children: [
                  Icon(
                    Icons.event_note,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      program.name ?? 'No Name',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Type: ${program.type ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                program.description ?? 'No Description',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Created: ${program.createdAt?.split('T').first ?? 'N/A'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    'Updated: ${program.updatedAt?.split('T').first ?? 'N/A'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Theme.of(context).primaryColor.withOpacity(0.3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Add action for viewing more details
                      navigateTo(context, ProgramDetailsScreen(programId: program.id!,));
                    },
                    icon: Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                    label: Text(
                      'Details',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      // Add favorite action
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


