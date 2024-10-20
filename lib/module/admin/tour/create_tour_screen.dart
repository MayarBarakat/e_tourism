import 'package:e_tourism/shared/cubit/tour_cubit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../shared/componenet/components.dart'; // لتنسيق التاريخ

class CreateTourScreen extends StatefulWidget {
  const CreateTourScreen({super.key});

  @override
  _CreateTourScreenState createState() => _CreateTourScreenState();
}

class _CreateTourScreenState extends State<CreateTourScreen> {
  final TextEditingController programIdController = TextEditingController();
  final TextEditingController driverIdController = TextEditingController();
  final TextEditingController guideIdController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // لفتح اختيار التاريخ
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked); // تنسيق التاريخ
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Tour'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Add New Tour',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              const SizedBox(height: 30),

              // حقل معرف البرنامج (Program ID)
              MyTextField(
                controller: programIdController,
                hintText: 'Program ID',
                obscureText: false,
                inputType: TextInputType.number,
                prefixIcon: FontAwesomeIcons.clipboard,
              ),
              const SizedBox(height: 20),

              // حقل معرف السائق (Driver ID)
              MyTextField(
                controller: driverIdController,
                hintText: 'Driver ID',
                obscureText: false,
                inputType: TextInputType.number,
                prefixIcon: FontAwesomeIcons.car,
              ),
              const SizedBox(height: 20),

              // حقل معرف الدليل (Guide ID)
              MyTextField(
                controller: guideIdController,
                hintText: 'Guide ID',
                obscureText: false,
                inputType: TextInputType.number,
                prefixIcon: FontAwesomeIcons.userTie,
              ),
              const SizedBox(height: 20),

              // حقل السعر (Price)
              MyTextField(
                controller: priceController,
                hintText: 'Price',
                obscureText: false,
                inputType: TextInputType.number,
                prefixIcon: FontAwesomeIcons.dollarSign,
              ),
              const SizedBox(height: 20),

              // حقل تاريخ البدء (Start Date)
              MyTextField(
                controller: startDateController,
                hintText: 'Start Date',
                obscureText: false,
                inputType: TextInputType.datetime,
                prefixIcon: FontAwesomeIcons.calendar,
                onTap: () => _selectDate(context, startDateController),
              ),
              const SizedBox(height: 20),

              // حقل تاريخ الانتهاء (End Date)
              MyTextField(
                controller: endDateController,
                hintText: 'End Date',
                obscureText: false,
                inputType: TextInputType.datetime,
                prefixIcon: FontAwesomeIcons.calendarAlt,
                onTap: () => _selectDate(context, endDateController),
              ),
              const SizedBox(height: 30),

              // زر إضافة الجولة
              CustomButton(
                text: 'Create Tour',
                icon: FontAwesomeIcons.check,
                onPressed: () {
                  // استدعاء دالة الإضافة من TourCubit
                  TourCubit.get(context).createTour(
                    context: context,
                    programId: int.parse(programIdController.text),
                    driverId: int.parse(driverIdController.text),
                    guideId: int.parse(guideIdController.text),
                    price: priceController.text,
                    start_date: startDateController.text,
                    end_date: endDateController.text,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
