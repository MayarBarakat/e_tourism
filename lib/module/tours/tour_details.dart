import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_tourism/shared/cubit/tour_cubit.dart'; // Update with your actual path

class TourDetailsScreen extends StatefulWidget {
  final int tourId; // Receive tour ID as a parameter

  const TourDetailsScreen({super.key, required this.tourId});

  @override
  _TourDetailsScreenState createState() => _TourDetailsScreenState();
}

class _TourDetailsScreenState extends State<TourDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the tour details when the screen is built
    context.read<TourCubit>().getTourDetails(context: context, tourId: widget.tourId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TourCubit, TourState>(
      listener: (context, state) {
        // Handle state changes if needed (e.g., show snackbars for errors)
      },
      builder: (context, state) {
        var cubit = TourCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Tour Details'),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 4,
          ),
          body: cubit.loadingTourDetails
              ? const Center(child: CircularProgressIndicator()) // Show loading indicator
              : cubit.tourDetailsModel.data != null
              ? SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cubit.tourDetailsModel.data!.program?.name ?? 'Unknown Program',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 10),
                Text(
                  'Price: ${cubit.tourDetailsModel.data!.price} SYM',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.green[800]),
                ),
                const SizedBox(height: 10),
                _buildDetailRow('Start Date:', cubit.tourDetailsModel.data!.startDate),
                _buildDetailRow('End Date:', cubit.tourDetailsModel.data!.endDate),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 10),
                _buildDetailRow('Guide ID:', cubit.tourDetailsModel.data!.guideId?.toString() ?? 'N/A'),
                _buildDetailRow('Driver ID:', cubit.tourDetailsModel.data!.driverId?.toString() ?? 'N/A'),
                _buildDetailRow('Number of Participants:', cubit.tourDetailsModel.data!.number?.toString() ?? 'N/A'),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 10),
                _buildDetailRow('Created At:', cubit.tourDetailsModel.data!.createdAt ?? 'N/A'),
                _buildDetailRow('Updated At:', cubit.tourDetailsModel.data!.updatedAt ?? 'N/A'),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.registerInTour(context: context, tourId: cubit.tourDetailsModel.data!.id!);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15), // Increased padding for better touch area
                      backgroundColor: Theme.of(context).primaryColor, // Use primary color from theme for consistency
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // More rounded for a modern, sleek look
                      ),
                      elevation: 8, // Enhanced elevation for greater depth
                      shadowColor: Colors.black.withOpacity(0.3), // Slightly darker shadow for a more pronounced effect
                      textStyle: const TextStyle(
                        fontSize: 20, // Increased font size for better readability
                        fontWeight: FontWeight.bold, // Bold for prominence
                        letterSpacing: 1.2, // Added letter spacing for a cleaner, more spaced-out look
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Keeps the button size compact around its content
                      children: const [
                        Icon(Icons.directions_run, size: 24, color: Colors.white), // Added an icon for better UX
                        SizedBox(width: 10), // Spacing between icon and text
                        Text('Register for Tour',style: TextStyle(color: Colors.white),), // Button text
                      ],
                    ),
                  ),
                ),


              ],
            ),
          )
              : const Center(
            child: Text(
              'No details available.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            value ?? 'N/A',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
