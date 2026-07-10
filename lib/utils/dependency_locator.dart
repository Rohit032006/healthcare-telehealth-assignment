import 'package:get_it/get_it.dart';
import '../features/appointment/repo/appointment_repo.dart';
import '../features/auth/repo/auth_repo.dart';
import '../features/configuration/repo/configuration_repo.dart';
import '../features/bottom_nav_bar/repo/bottom_bar_repo.dart';
import '../features/session_notes/repo/session_notes_repo.dart';
import '../features/video_call/repo/video_call_repo.dart';
import 'networks/app_interceptor.dart';
import 'networks/end_point.dart';
import 'networks/network_service.dart';

GetIt getIt = GetIt.instance;
void initDependencyLocator() {
  getIt
    ..registerLazySingleton<AppInterceptor>(() => AppInterceptor(EndPoint.appBaseUrl))
    ..registerLazySingleton<NetworkService>(() => NetworkService())
    ..registerLazySingleton<IConfigurationRepo>(() => ConfigurationRepo())
    ..registerLazySingleton<BottomRepo>(() => BottomRepoImpl())
    ..registerLazySingleton<IAuthRepo>(() => AuthRepo())
    ..registerLazySingleton<IAppointmentRepo>(() => AppointmentRepo())
    ..registerLazySingleton<IVideoCallRepo>(() => VideoCallRepo())
    ..registerLazySingleton<ISessionNotesRepo>(() => SessionNotesRepo());
}
