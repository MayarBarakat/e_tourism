import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_tourism/shared/cubit/tour_cubit.dart';

class ProgramDetailsScreen extends StatelessWidget {
  final int programId;

  const ProgramDetailsScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    // Call getProgramDetails to fetch data
    context.read<TourCubit>().getProgramDetails(context: context, programId: programId);

    return BlocConsumer<TourCubit, TourState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TourCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('Program Details', style: TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: cubit.loadingProgramDetails
              ? Center(child: CircularProgressIndicator())
              : cubit.programData.data != null
              ? SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Program Title
                Text(
                  cubit.programData.data!.name ?? 'No Name',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),

                // Program Type
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Type: ${cubit.programData.data!.type ?? 'N/A'}',
                    style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(height: 16),

                // Program Description
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    cubit.programData.data!.description ?? 'No Description',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
                const SizedBox(height: 16),

                // Created and Updated Dates
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Created: ${cubit.programData.data!.createdAt?.split('T').first ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      'Updated: ${cubit.programData.data!.updatedAt?.split('T').first ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Additional Info Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This program includes various historical sites and events. Be sure to check the schedule for the latest updates.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              : Center(
            child: Text(
              'No program details available.',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
          ),
        );
      },
    );
  }
}
