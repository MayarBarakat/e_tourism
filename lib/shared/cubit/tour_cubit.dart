import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_tourism/models/admin_models/create_program_model.dart';
import 'package:e_tourism/models/admin_models/create_tour_model.dart';
import 'package:e_tourism/models/programs_models/all_programs_model.dart';
import 'package:e_tourism/models/programs_models/program_data_model.dart';
import 'package:e_tourism/models/report/report_model.dart';
import 'package:e_tourism/models/tours_model/all_tours_model.dart';
import 'package:e_tourism/models/tours_model/tour_deatils_model.dart';
import 'package:e_tourism/models/user_model/user_model.dart';
import 'package:e_tourism/module/admin/admin_screen.dart';
import 'package:e_tourism/module/programs/programs_screen.dart';
import 'package:e_tourism/module/settings/settings_screen.dart';
import 'package:e_tourism/module/tours/tours_screen.dart';
import 'package:e_tourism/shared/network/end_points.dart';
import 'package:e_tourism/shared/network/remote/consts.dart';
import 'package:e_tourism/shared/network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../layout/tour_layout.dart';
import '../../module/Auth_screens/login/login_screen.dart';
import '../componenet/components.dart';
import '../network/local/cache_helper.dart';

part 'tour_state.dart';

class TourCubit extends Cubit<TourState> {
  TourCubit() : super(TourInitial());
  static TourCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  void changeBottom(int index) {
    currentIndex = index;
    emit(TourChangeBottomState());
  }
  List<Widget> bottomScreens = [
    ProgramsScreen(),
    ToursScreen(),
    AdminScreen(),
    SettingsScreen(),
  ];
  bool loadingLogin = false;
  late UserModel userModel;


  //////////// Login method //////////////
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    loadingLogin = true;
    emit(TourLoginLoadingState());

    try {
      final response = await DioHelper.postData(url: LOGIN, data: {
        'email': email,
        'password': password,
      });

      bool status = response.data['status'] == 'success'; // Check for 'success' status

      if (status) {
        // Successful login
        userModel = UserModel.fromJson(response.data);
        showAwesomeSnackbar(
          context: context,
          message: 'Login Successfully',
          contentType: ContentType.success,
        );

        // Save token in Cache
        token = userModel.data!.token!;
        String role = userModel.data!.user!.role!;
        await CacheHelper.saveData(key: 'token', value: token);
        await CacheHelper.saveData(key: 'role', value: role);

        loadingLogin = false;
        emit(TourLoginSuccessfullyState());

        // Navigate to main layout
        navigateAndFinish(context, TourLayout());
      } else {
        // Login failed, show error message
        final errorMessage = response.data['message'];
        String displayMessage = "";

        // Check if the message is a map, in case there are validation errors
        if (errorMessage is Map && errorMessage.containsKey('email')) {
          displayMessage = errorMessage['email'][0]; // Shows the first error message related to email
        } else {
          displayMessage = errorMessage; // General error message
        }

        showAwesomeSnackbar(
          context: context,
          message: displayMessage,
          contentType: ContentType.failure, // Use 'failure' for errors
        );

        loadingLogin = false;
        emit(TourLoginErrorState()); // You can create this state for the failed case
      }
    } catch (error) {
      // Handle general errors (like network issues, server issues)
      showAwesomeSnackbar(
        context: context,
        message: 'An error occurred, please try again.',
        contentType: ContentType.failure,
      );

      loadingLogin = false;
      print(error.toString());
      emit(TourLoginErrorState());
    }
  }


  ///////////// signup method /////////////
  bool loadingSignup = false;
  Future<void> signup({
    required BuildContext context,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String description,
})async{
    loadingSignup = true;
    emit(TourSignupLoadingState());
    try{
      final response = await DioHelper.postData(url: SIGNUP, data: {
        'email':email,
        'password':password,
        'fName':firstName,
        'lName':lastName,
        'description':description,
      });
      bool status = response.data['status'] == 'success'; // Check for 'success' status

      if (status) {
        // Successful login
        userModel = UserModel.fromJson(response.data);
        showAwesomeSnackbar(
          context: context,
          message: 'Signup Successfully',
          contentType: ContentType.success,
        );

        // Save token in Cache
        token = userModel.data!.token!;
        String role = userModel.data!.user!.role!;
        await CacheHelper.saveData(key: 'token', value: token);
        await CacheHelper.saveData(key: 'role', value: role);

        loadingSignup = false;
        emit(TourSignupSuccessfullyState());

        // Navigate to main layout
        navigateAndFinish(context, TourLayout());
      } else {
        // Login failed, show error message
        final errorMessage = response.data['message'];
        String displayMessage = "";

        // Check if the message is a map, in case there are validation errors
        if (errorMessage is Map && errorMessage.containsKey('email')) {
          displayMessage = errorMessage['email'][0]; // Shows the first error message related to email
        } else {
          displayMessage = errorMessage; // General error message
        }

        showAwesomeSnackbar(
          context: context,
          message: displayMessage,
          contentType: ContentType.failure, // Use 'failure' for errors
        );

        loadingSignup = false;
        emit(TourSignupErrorState()); // You can create this state for the failed case
      }
    } catch (error) {
      // Handle general errors (like network issues, server issues)
      showAwesomeSnackbar(
        context: context,
        message: 'An error occurred, please try again.',
        contentType: ContentType.failure,
      );

      loadingSignup = false;
      print(error.toString());
      emit(TourSignupErrorState());
    }
  }

  ////////////// get all programs method ///////////////
  bool loadingAllPrograms = false;
  late AllProgramsModel allProgramsModel;

  Future<void> getAllPrograms({
    required BuildContext context,
  }) async {
    loadingAllPrograms = true;
    emit(TourGetAllProgramsLoadingState());

    try {
      final response = await DioHelper.getData(
        url: ALL_PROGRAMS,
        token: CacheHelper.getData(key: 'token'),
      );

      allProgramsModel = AllProgramsModel.fromJson(response.data);

      if (allProgramsModel.status == 'success') {

        loadingAllPrograms = false;
        emit(TourGetAllProgramsSuccessfullyState());
      } else {

        loadingAllPrograms = false;
        emit(TourGetAllProgramsErrorState());
      }
    } catch (error) {

      print(error.toString());
      loadingAllPrograms = false;
      emit(TourGetAllProgramsErrorState());
    }
  }


  /////////////// get program details ///////
  bool loadingProgramDetails = false;
  late ProgramData programData;

  Future<void> getProgramDetails({
    required BuildContext context,
    required int programId,
  }) async {
    loadingProgramDetails = true;
    emit(TourGetProgramDataLoadingState());

    try {
      final response = await DioHelper.getData(
        url: '$ALL_PROGRAMS/$programId',
        token: CacheHelper.getData(key: 'token'),
      );

      programData = ProgramData.fromJson(response.data);

      if (programData.status == 'success') {

        loadingProgramDetails = false;
        emit(TourGetProgramDataSuccessfullyState());
      } else {
        showAwesomeSnackbar(
          context: context,
          message: programData.message ?? 'Failed to fetch program details',
          contentType: ContentType.failure,
        );
        loadingProgramDetails = false;
        emit(TourGetProgramDataErrorState());
      }
    } catch (error) {
      showAwesomeSnackbar(
        context: context,
        message: 'An error occurred, please try again.',
        contentType: ContentType.failure,
      );
      print(error.toString());
      loadingProgramDetails = false;
      emit(TourGetProgramDataErrorState());
    }
  }




////////////// getAllTours ///////////
  bool loadingAllTours = false;
  late ToursModel toursModel;

  Future<void> getAllTours({
    required BuildContext context,
  }) async {
    loadingAllTours = true;
    emit(TourGetAllToursLoadingState());

    try {
      final response = await DioHelper.getData(
        url: ALL_TOURS,
        token: CacheHelper.getData(key: 'token'),
      );

      toursModel = ToursModel.fromJson(response.data);

      if (toursModel.status == 'success') {
        loadingAllTours = false;
        emit(TourGetAllToursSuccessfullyState());
      } else {
        loadingAllTours = false;
        emit(TourGetAllToursErrorState());
      }
    } catch (error) {
      print(error.toString());
      loadingAllTours = false;
      emit(TourGetAllToursErrorState());
    }
  }


  /////////////////  getTourDetails ///////////////
  bool loadingTourDetails = false;
  late TourDetailsModel tourDetailsModel;

  Future<void> getTourDetails({
    required BuildContext context,
    required int tourId,
  }) async {
    loadingTourDetails = true;
    emit(TourGetTourDataLoadingState());

    try {
      final response = await DioHelper.getData(
        url: '$ALL_TOURS/$tourId', // Update this according to your actual API endpoint
        token: CacheHelper.getData(key: 'token'),
      );

      tourDetailsModel = TourDetailsModel.fromJson(response.data);

      if (tourDetailsModel.status == 'success') {
        // Successful response handling
        loadingTourDetails = false;
        emit(TourGetTourDataSuccessfullyState());
      } else {
        // Show error message using snackbar
        showAwesomeSnackbar(
          context: context,
          message: tourDetailsModel.message ?? 'Failed to fetch tour details',
          contentType: ContentType.failure,
        );
        loadingTourDetails = false;
        emit(TourGetTourDataErrorState());
      }
    } catch (error) {
      // Handle exceptions with a snackbar
      showAwesomeSnackbar(
        context: context,
        message: 'An error occurred, please try again.',
        contentType: ContentType.failure,
      );
      print(error.toString());
      loadingTourDetails = false;
      emit(TourGetTourDataErrorState());
    }
  }



///////// searchTours /////////
  Future<void> searchTours({
    required BuildContext context,
    required String query,
  }) async {
    // If the query is empty, reset to the original tours
    if (query.isEmpty) {
      emit(TourGetAllToursSuccessfullyState());
      return;
    }

    try {
      // Using the DioHelper to call the search endpoint
      final response = await DioHelper.getData(
        url: 'tours/search',  // Just the endpoint, as baseUrl is already set in DioHelper
        query: {'query': query}, // Passing the query as a parameter
        token: CacheHelper.getData(key: 'token'),
      );

      // Parse the response to the ToursModel
      toursModel = ToursModel.fromJson(response.data);
      print('Search results for query "$query": ${toursModel.data}');

      if (toursModel.status == 'success') {
        emit(TourSearchSuccessfullyState());
      } else {
        emit(TourSearchErrorState());
      }
    } catch (error) {
      print(error.toString());
      emit(TourSearchErrorState());
    }
  }


  /////////// createProgram /////////
  bool loadingCreateProgram = false;
  late CreateProgramModel createProgramModel;

  Future<void> createProgram({
    required BuildContext context,
    required String name,
    required String type,
    required String description,
  }) async {
    loadingCreateProgram = true;
    emit(TourCreateProgramLoadingState());

    try {
      final response = await DioHelper.postData(
        url: CREATE_PROGRAM,
        data: {
          'name': name,
          'type': type,
          'description': description,
        },
        token: CacheHelper.getData(key: 'token'),
      );

      createProgramModel = CreateProgramModel.fromJson(response.data);

      if (createProgramModel.status == 'success') {
        // Successful response handling
        loadingCreateProgram = false;
        refresh(context: context);
        emit(TourCreateProgramSuccessfullyState());
      } else {
        // Show error message using snackbar
        showAwesomeSnackbar(
          context: context,
          message: createProgramModel.message ?? 'Failed to create program',
          contentType: ContentType.failure,
        );
        loadingCreateProgram = false;
        emit(TourCreateProgramErrorState());
      }
    } catch (error) {
      // Handle exceptions with a snackbar
      showAwesomeSnackbar(
        context: context,
        message: 'An error occurred, please try again.',
        contentType: ContentType.failure,
      );
      print(error.toString());
      loadingCreateProgram = false;
      emit(TourCreateProgramErrorState());
    }
  }


  void refresh({required context})async{
    getAllPrograms(context: context);
    getAllTours(context: context);
  }


  Future<void> deleteProgram({
    required BuildContext context,
    required int programId,
    required String programName,
  }) async {
    bool confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the program "$programName"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // إلغاء الحذف
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // تأكيد الحذف
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ) ?? false;

    // إذا تم تأكيد الحذف
    if (confirmed) {
      try {
        final response = await DioHelper.deleteData(
          url: '$CREATE_PROGRAM/$programId',
          token: CacheHelper.getData(key: 'token'),
        );

        // إعادة تحميل البيانات بعد الحذف
        refresh(context: context);
        emit(TourDeleteProgramSuccessfullyState());

        // عرض رسالة نجاح
        showAwesomeSnackbar(
          context: context,
          message: 'Program "$programName" has been deleted successfully!',
          contentType: ContentType.success,
        );

      } catch (error) {
        print(error.toString());
        emit(TourDeleteProgramErrorState());

        // عرض رسالة خطأ
        showAwesomeSnackbar(
          context: context,
          message: 'Failed to delete the program "$programName". Please try again.',
          contentType: ContentType.failure,
        );
      }
    }
  }



  /////////////////
  Future<void> updateProgram({
    required BuildContext context,
    required int programId,
    required String programName, // اسم البرنامج الجديد
  }) async {
    try {
      final response = await DioHelper.postData(
        url: '$CREATE_PROGRAM/$programId',
        token: CacheHelper.getData(key: 'token'),
        data: {
          'name': programName,
          '_method':'PUT'
        },
      );
      print(response.data);
      // إعادة تحميل البيانات بعد التحديث
      refresh(context: context);
      Navigator.pop(context);
      emit(TourUpdateProgramSuccessfullyState());

      // عرض رسالة نجاح
      showAwesomeSnackbar(
        context: context,
        message: 'Program "$programName" has been updated successfully!',
        contentType: ContentType.success,
      );

    } catch (error) {
      print(error.toString());
      emit(TourUpdateProgramErrorState());

      // عرض رسالة خطأ
      showAwesomeSnackbar(
        context: context,
        message: 'Failed to update the program "$programName". Please try again.',
        contentType: ContentType.failure,
      );
    }
  }


  Future<void> deleteTour({
    required BuildContext context,
    required int tourId,
    required String tourName,
  }) async {
    bool confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the Tour "$tourName"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // إلغاء الحذف
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // تأكيد الحذف
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ) ?? false;

    if (confirmed) {
      try {
        final response = await DioHelper.deleteData(
          url: '$CREATE_TOUR/$tourId',
          token: CacheHelper.getData(key: 'token'),
        );

        // إعادة تحميل البيانات بعد الحذف
        refresh(context: context);
        emit(TourDeleteTourSuccessfullyState());

        // عرض رسالة نجاح
        showAwesomeSnackbar(
          context: context,
          message: 'Program "$tourName" has been deleted successfully!',
          contentType: ContentType.success,
        );

      } catch (error) {
        print(error.toString());
        emit(TourDeleteTourErrorState());

        showAwesomeSnackbar(
          context: context,
          message: 'Failed to delete the program "$tourName". Please try again.',
          contentType: ContentType.failure,
        );
      }
    }
  }


  Future<void> updateTour({
    required BuildContext context,
    required int tourId,
    required String tourPrice,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: '$CREATE_TOUR/$tourId',
        token: CacheHelper.getData(key: 'token'),
        data: {
          'price': tourPrice,
          '_method':'PUT'
        },
      );
      print(response.data);
      // إعادة تحميل البيانات بعد التحديث
      refresh(context: context);
      Navigator.pop(context);
      emit(TourUpdateTourSuccessfullyState());

      // عرض رسالة نجاح
      showAwesomeSnackbar(
        context: context,
        message: 'Program "$tourPrice" has been updated successfully!',
        contentType: ContentType.success,
      );

    } catch (error) {
      print(error.toString());
      emit(TourUpdateTourErrorState());

      showAwesomeSnackbar(
        context: context,
        message: 'Failed to update the program "$tourPrice". Please try again.',
        contentType: ContentType.failure,
      );
    }
  }


  bool loadingCreateTour = false;
  late CreateTourModel createTourModel;
  Future<void> createTour({
    required BuildContext context,
    required int programId,
    required int driverId,
    required int guideId,
    required String price,
    required String start_date,
    required String end_date,
  }) async {
    loadingCreateTour = true;
    emit(TourCreateTourLoadingState());

    try {
      final response = await DioHelper.postData(
        url: CREATE_TOUR,
        data: {
          'program_id': programId,
          'driver_id': driverId,
          'guide_id': guideId,
          'price': price,
          'start_date': start_date,
          'end_date': end_date,
        },
        token: CacheHelper.getData(key: 'token'),
      );

      createTourModel = CreateTourModel.fromJson(response.data);


        // Successful response handling
        loadingCreateTour = false;
        refresh(context: context);
        emit(TourCreateTourSuccessfullyState());

    } catch (error) {
      // Handle exceptions with a snackbar
      refresh(context: context);

      print(error.toString());
      loadingCreateTour = false;
      emit(TourCreateTourErrorState());
    }
  }

  Future<void> logout({
    required BuildContext context
})async {
    try{
      final response = await DioHelper.postData(url: LOGOUT, data: {},token: CacheHelper.getData(key: 'token'));
      CacheHelper.removeData(key: 'role');
      CacheHelper.removeData(key: 'token').then((value) {
        if (value) {
          currentIndex = 0;
          emit(TourLogoutSuccessfullyState());
          navigateAndFinish(context, LoginScreen());
        }
      }).catchError((error) {
        print('Logout Error: $error');
      });
    }catch(error){
      print(error.toString());
      emit(TourLogoutErrorState());
    }

  }
  bool loadingReport = false;
  late ReportModel reportModel;
  Future<void> getReport({
    required BuildContext context,
    required String startDate,
    required String endDate,
  }) async {
    // التحقق من إدخال التواريخ (يمكنك تخصيص هذه الرسالة كما تريد)
    if (startDate.isEmpty || endDate.isEmpty) {
      emit(TourGetTourReportErrorState());
      return;
    }

    try {
      // استدعاء الـ API باستخدام DioHelper
      final response = await DioHelper.getData(
        url: REPORT,  // Endpoint فقط لأن baseUrl محدد بالفعل في DioHelper
        query: {
          'start_date': startDate,
          'end_date': endDate,
        },
        token: CacheHelper.getData(key: 'token'),
      );
      // تحويل الاستجابة إلى نموذج ReportModel
      reportModel = ReportModel.fromJson(response.data);

      print('Report for dates $startDate to $endDate: ${reportModel.data}');

      // التحقق من حالة الاستجابة
      if (reportModel.status == 'success') {
        emit(TourGetTourReportSuccessfullyState());  // حالة النجاح مع البيانات
      } else {
        print(response.data['message']);
        emit(TourGetTourReportErrorState());
      }
    } catch (error) {
      print(";;;;;;;;;;;;;;;;;;;;");
      print(error.toString());
      print('Error registering in tour: $error');
      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data ?? errorMessage;
      }
      print(errorMessage);
      emit(TourGetTourReportErrorState());  // في حالة حدوث خطأ
    }
  }
  bool loadingRegisterInTour = false;

  Future<void> registerInTour({
    required BuildContext context,
    required int tourId,
  }) async {
    loadingRegisterInTour = true;
    emit(TourRegisterInTourLoadingState());

    try {
      // إرسال الطلب عبر DioHelper
      final response = await DioHelper.postData(
        url: '$REPORT/$tourId',
        data: {}, // يمكن إضافة البيانات الإضافية هنا إذا كانت مطلوبة
        token: CacheHelper.getData(key: 'token'), // تمرير التوكن للتأكد من صلاحيات المستخدم
      );

      // التحقق من نجاح العملية
      if (response.data['status'] == 'success') {
        Navigator.pop(context);
        // عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
        emit(TourRegisterInTourSuccessfullyState());
      } else {
        // عرض رسالة فشل في حالة عدم النجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data['message'] ?? 'Registration failed.'),
            backgroundColor: Colors.red,
          ),

        );
        emit(TourRegisterInTourErrorState());
      }
    } catch (error) {
      // التعامل مع الخطأ وعرض رسالة للمستخدم
      print('Error registering in tour: $error');
      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data ?? errorMessage;
      }
      print(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      emit(TourRegisterInTourErrorState());
    } finally {
      loadingRegisterInTour = false;
    }
  }

}
