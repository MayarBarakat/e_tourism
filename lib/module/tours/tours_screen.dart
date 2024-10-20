import 'package:e_tourism/module/tours/tour_details.dart';
import 'package:e_tourism/shared/componenet/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_tourism/shared/cubit/tour_cubit.dart';
import '../../models/tours_model/all_tours_model.dart'; // Update with your actual model path

class ToursScreen extends StatefulWidget {
  const ToursScreen({super.key});

  @override
  _ToursScreenState createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  String query = '';
  FocusNode searchFocusNode = FocusNode(); // Define a FocusNode to manage keyboard focus

  @override
  void initState() {
    super.initState();
    // Fetch the tours when the screen is built
    context.read<TourCubit>().getAllTours(context: context);
  }

  @override
  void dispose() {
    searchFocusNode.dispose(); // Dispose of the FocusNode when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TourCubit, TourState>(
      listener: (context, state) {
        // Handle state changes if needed
        if (state is TourGetAllToursSuccessfullyState) {
          searchFocusNode.unfocus(); // Unfocus to close the keyboard after data is fetched
        }
      },
      builder: (context, state) {
        var cubit = TourCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Available Tours'),
            backgroundColor: Theme.of(context).primaryColor,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    focusNode: searchFocusNode, // Attach the focus node here
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                      // Call the search function from your cubit
                      context.read<TourCubit>().searchTours(context: context, query: query);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search tours...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            query = '';
                          });
                          context.read<TourCubit>().searchTours(context: context, query: query);
                        },
                      )
                          : null,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          body: cubit.loadingAllTours
              ? const Center(child: CircularProgressIndicator())
              : cubit.toursModel.data != null && cubit.toursModel.data!.isNotEmpty
              ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: cubit.toursModel.data!.length,
            itemBuilder: (context, index) {
              var tour = cubit.toursModel.data![index];
              return TourCard(tour: tour,searchFocusNode: searchFocusNode,);
            },
          )
              : const Center(
            child: Text(
              'No tours available.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

class TourCard extends StatelessWidget {
  final Data tour;
  final searchFocusNode;

  const TourCard({super.key, required this.tour,required this.searchFocusNode});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tour Program Name
            Text(
              tour.program?.name ?? 'Unknown Program',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),

            // Price Row
            Row(
              children: [
                const Icon(Icons.money, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  'Price: ${tour.price} SYM',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Start Date Row
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  'Start Date: ${tour.startDate}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // End Date Row
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  'End Date: ${tour.endDate}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // More Info Button
            ElevatedButton(
              onPressed: () {
                searchFocusNode.unfocus(); // Close the keyboard before navigating
                navigateTo(context, TourDetailsScreen(tourId: tour.program!.id!));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Increased border radius for a softer look
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Increased padding for better touch target
                elevation: 5, // Added shadow elevation for depth
                shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow for depth
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min, // Use minimum size to fit the content
                children: [
                  Icon(Icons.info, color: Colors.white), // Icon for visual context
                  SizedBox(width: 8), // Space between icon and text
                  Text(
                    'More Info',
                    style: TextStyle(
                      fontSize: 16, // Adjusted font size for readability
                      fontWeight: FontWeight.bold, // Bold text for emphasis
                      color: Colors.white, // Text color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
