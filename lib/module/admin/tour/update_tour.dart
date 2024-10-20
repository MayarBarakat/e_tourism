import 'package:e_tourism/shared/cubit/tour_cubit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/componenet/components.dart';

class UpdateDeleteTourScreen extends StatelessWidget {
  final String tourPrice;
  final int tourId;

  const UpdateDeleteTourScreen({
    super.key,
    required this.tourPrice,
    required this.tourId,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController(text: tourPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Tour'),
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
              'Manage Tour',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            const SizedBox(height: 30),
            MyTextField(
              controller: priceController,
              hintText: 'Tour Name',
              obscureText: false,
              inputType: TextInputType.text,
              prefixIcon: FontAwesomeIcons.map,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Update Tour',
              icon: FontAwesomeIcons.pen,
              onPressed: () {
                // استدعاء دالة التحديث مع الاسم الجديد
                TourCubit.get(context).updateTour(
                  context: context,
                  tourId: tourId,
                  tourPrice: priceController.text,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
