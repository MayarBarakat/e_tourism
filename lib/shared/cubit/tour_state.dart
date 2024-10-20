part of 'tour_cubit.dart';

@immutable
sealed class TourState {}

final class TourInitial extends TourState {}
final class TourChangeBottomState extends TourState {}

final class TourLoginSuccessfullyState extends TourState {}
final class TourLoginLoadingState extends TourState {}
final class TourLoginErrorState extends TourState {}

final class TourSignupSuccessfullyState extends TourState {}
final class TourSignupLoadingState extends TourState {}
final class TourSignupErrorState extends TourState {}

final class TourGetAllProgramsSuccessfullyState extends TourState {}
final class TourGetAllProgramsLoadingState extends TourState {}
final class TourGetAllProgramsErrorState extends TourState {}

final class TourGetProgramDataSuccessfullyState extends TourState {}
final class TourGetProgramDataLoadingState extends TourState {}
final class TourGetProgramDataErrorState extends TourState {}

final class TourGetAllToursSuccessfullyState extends TourState {}
final class TourGetAllToursLoadingState extends TourState {}
final class TourGetAllToursErrorState extends TourState {}

final class TourGetTourDataSuccessfullyState extends TourState {}
final class TourGetTourDataLoadingState extends TourState {}
final class TourGetTourDataErrorState extends TourState {}


final class TourSearchSuccessfullyState extends TourState {}
final class TourSearchLoadingState extends TourState {}
final class TourSearchErrorState extends TourState {}


final class TourCreateProgramSuccessfullyState extends TourState {}
final class TourCreateProgramLoadingState extends TourState {}
final class TourCreateProgramErrorState extends TourState {}


final class TourCreateTourSuccessfullyState extends TourState {}
final class TourCreateTourLoadingState extends TourState {}
final class TourCreateTourErrorState extends TourState {}

final class TourGetTourReportSuccessfullyState extends TourState {}
final class TourGetTourReportLoadingState extends TourState {}
final class TourGetTourReportErrorState extends TourState {}

final class TourRegisterInTourSuccessfullyState extends TourState {}
final class TourRegisterInTourLoadingState extends TourState {}
final class TourRegisterInTourErrorState extends TourState {}

final class TourDeleteProgramSuccessfullyState extends TourState {}
final class TourDeleteProgramErrorState extends TourState {}

final class TourUpdateProgramSuccessfullyState extends TourState {}
final class TourUpdateProgramErrorState extends TourState {}


final class TourDeleteTourSuccessfullyState extends TourState {}
final class TourDeleteTourErrorState extends TourState {}

final class TourUpdateTourSuccessfullyState extends TourState {}
final class TourUpdateTourErrorState extends TourState {}

final class TourLogoutSuccessfullyState extends TourState {}
final class TourLogoutErrorState extends TourState {}

