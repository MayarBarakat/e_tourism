import 'package:e_tourism/layout/tour_layout.dart';
import 'package:e_tourism/shared/cubit/tour_cubit.dart';
import 'package:e_tourism/shared/network/local/cache_helper.dart';
import 'package:e_tourism/shared/network/remote/dio_helper.dart';
import 'package:e_tourism/shared/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'module/Auth_screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  await CacheHelper.init();

  // Check if there is a token stored in cache
  // CacheHelper.removeData(key: 'token');
  String? token = CacheHelper.getData(key: 'token');

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => TourCubit(),
        ),
      ],
      child: BlocConsumer<TourCubit, TourState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme(),
            home: Scaffold(
              body: token != null ?  TourLayout() : LoginScreen(),
            ),
          );
        },
      ),
    );
  }
}

