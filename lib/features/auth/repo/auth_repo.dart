import 'package:get_storage/get_storage.dart';

import '../../../utils/constants/local_storage_key_strings.dart';
import '../../../utils/constants/mock_data.dart';
import '../model/doctor_user.dart';

abstract class IAuthRepo {
  Future<DoctorUser> login(String email, String password);
  Future<void> logout();
  bool get isLoggedIn;
}

/// Mocked auth backend for the assignment — mimics network latency and
/// persists a fake session the same way a real login response would.
class AuthRepo implements IAuthRepo {
  @override
  Future<DoctorUser> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (email.trim().toLowerCase() != MockData.doctorEmail ||
        password != MockData.doctorPassword) {
      throw Exception('Invalid email or password');
    }

    final doctor = const DoctorUser(
      id: MockData.doctorId,
      name: MockData.doctorName,
      email: MockData.doctorEmail,
    );

    final storage = GetStorage();
    await storage.write(LocalStorageKeyStrings.isLogin, true);
    await storage.write(LocalStorageKeyStrings.accessToken, 'mock-jwt-token');
    await storage.write(LocalStorageKeyStrings.loggedInUserId, doctor.id);
    await storage.write(LocalStorageKeyStrings.userName, doctor.name);

    return doctor;
  }

  @override
  Future<void> logout() async {
    final storage = GetStorage();
    await storage.remove(LocalStorageKeyStrings.isLogin);
    await storage.remove(LocalStorageKeyStrings.accessToken);
    await storage.remove(LocalStorageKeyStrings.loggedInUserId);
    await storage.remove(LocalStorageKeyStrings.userName);
  }

  @override
  bool get isLoggedIn =>
      GetStorage().read(LocalStorageKeyStrings.isLogin) ?? false;
}
