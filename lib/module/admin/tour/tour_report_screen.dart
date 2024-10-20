import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:e_tourism/shared/cubit/tour_cubit.dart';

class TourReportScreen extends StatefulWidget {
  const TourReportScreen({super.key});

  @override
  _TourReportScreenState createState() => _TourReportScreenState();
}

class _TourReportScreenState extends State<TourReportScreen> {
  // المتحكمات لتواريخ البداية والنهاية
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // لفتح منتقي التاريخ
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TourCubit, TourState>(
      listener: (context, state) {
        if (state is TourGetTourReportErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No Drivers between this days. Please try again.')),
          );
        }
      },
      builder: (context, state) {
        var cubit = TourCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tour Report'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Select Date Range',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                const SizedBox(height: 20),
                // حقل اختيار تاريخ البداية
                TextField(
                  controller: startDateController,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, startDateController),
                ),
                const SizedBox(height: 20),
                // حقل اختيار تاريخ النهاية
                TextField(
                  controller: endDateController,
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, endDateController),
                ),
                const SizedBox(height: 30),
                // زر جلب التقرير
                ElevatedButton.icon(
                  onPressed: () {
                    cubit.getReport(
                      context: context,
                      startDate: startDateController.text,
                      endDate: endDateController.text,
                    );
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Generate Report',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // عرض مؤشر التحميل إذا كانت البيانات تحت التحميل
                if (state is TourGetTourReportLoadingState)
                  const Center(child: CircularProgressIndicator()),

                // عرض النتائج بعد الحصول على التقرير
                if (state is TourGetTourReportSuccessfullyState)
                  Expanded(
                    child: ListView.builder(
                      itemCount: cubit.reportModel.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final report = cubit.reportModel.data![index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text('Driver ID: ${report.driverId}'),
                            subtitle: Text('Total Tours: ${report.totalTours}\nPlate Number: ${report.driver?.plateNumber}'),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
