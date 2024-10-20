import 'package:e_tourism/module/admin/tour/create_tour_screen.dart';
import 'package:e_tourism/module/admin/tour/update_tour.dart';
import 'package:e_tourism/module/admin/tour/tour_report_screen.dart'; // استيراد شاشة تقرير الجولات
import 'package:e_tourism/shared/cubit/tour_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/componenet/components.dart';

class ToursManagementScreen extends StatelessWidget {
  const ToursManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TourCubit, TourState>(
      listener: (context, state) {
        // يمكنك إضافة ردود الفعل هنا عند تغييرات الحالة
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tours Management'),
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
                  'Manage Tours',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                const SizedBox(height: 30),
                _buildActionButton(
                  context,
                  title: 'Create Tour',
                  color: Colors.teal.shade400,
                  icon: FontAwesomeIcons.plus,
                  onTap: () {
                    navigateTo(context, const CreateTourScreen());
                  },
                ),
                const SizedBox(height: 20),
                // إضافة زر جديد للذهاب إلى شاشة تقرير الجولات
                _buildActionButton(
                  context,
                  title: 'Tour Report',
                  color: Colors.blue.shade400,
                  icon: FontAwesomeIcons.fileAlt,
                  onTap: () {
                    navigateTo(context, const TourReportScreen());
                  },
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: _buildToursList(context), // وظيفة لعرض جميع الجولات
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

  Widget _buildToursList(BuildContext context) {
    var cubit = TourCubit.get(context);
    final tours = cubit.toursModel.data;

    if (tours == null || tours.isEmpty) {
      return const Center(
        child: Text(
          'No tours available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.map, color: Colors.teal),
            title: Text(
              tour.program!.name!, // استخدام اسم البرنامج المرتبط بالجولة
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'ID: ${tour.programId}\nPrice: ${tour.price}\nStart: ${tour.startDate}\nEnd: ${tour.endDate}', // عرض تفاصيل الجولة
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.pen, color: Colors.blue),
                  onPressed: () {
                    // الذهاب إلى شاشة التعديل
                    navigateTo(context, UpdateDeleteTourScreen(
                      tourId: tour.programId!,
                      tourPrice: tour.price!,
                    ));
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.trash, color: Colors.red),
                  onPressed: () {
                    cubit.deleteTour(context: context, tourId: tour.programId!, tourName: tour.program!.name!);
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
