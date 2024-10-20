import 'package:e_tourism/shared/cubit/tour_cubit.dart';
import 'package:e_tourism/shared/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class TourLayout extends StatefulWidget {
  const TourLayout({super.key});

  @override
  State<TourLayout> createState() => _TourLayoutState();
}

class _TourLayoutState extends State<TourLayout> {
  @override
  Widget build(BuildContext context) {
    var cubit = TourCubit.get(context);

    return BlocConsumer<TourCubit, TourState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            body: IndexedStack(
              index: cubit.currentIndex,
              children: cubit.bottomScreens, // Replace with actual screens for each section
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8),
                child: GNav(
                  backgroundColor: kPrimaryColor,
                  color: Colors.white,
                  activeColor: kSecondaryColor,
                  tabBackgroundColor: Colors.white.withOpacity(0.1),
                  gap: 8,
                  padding: const EdgeInsets.all(12),
                  selectedIndex: cubit.currentIndex,
                  onTabChange: (index) {
                    cubit.changeBottom(index);
                  },
                  tabs: const [
                    GButton(
                      icon: Icons.event_note,
                      text: 'Programs',
                    ),
                    GButton(
                      icon: Icons.tour,
                      text: 'Tours',
                    ),
                    GButton(
                      icon: Icons.admin_panel_settings,
                      text: 'Admin',
                    ),
                    GButton(
                      icon: Icons.settings,
                      text: 'Settings',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
