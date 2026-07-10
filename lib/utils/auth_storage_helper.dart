import 'package:get_storage/get_storage.dart';

import '../features/login/model/login_response.dart';
import 'constants/local_storage_key_strings.dart';
import 'dependency_locator.dart';
import 'networks/network_service.dart';

class AuthStorageHelper {
  static saveTokenPreferences(LoginResponse loginResponse) {
    final NetworkService service = getIt<NetworkService>();

    GetStorage().write(LocalStorageKeyStrings.loginResp, loginResponse.toJson());
    GetStorage().write(LocalStorageKeyStrings.accessToken, "${loginResponse.accessToken}");
    GetStorage().write(LocalStorageKeyStrings.refreshToken, "${loginResponse.refreshToken}");
    GetStorage().write(LocalStorageKeyStrings.loggedInUserId, loginResponse.user?.id);

    final firstName = loginResponse.user?.firstName ?? '';
    final lastName = loginResponse.user?.lastName ?? '';
    final userName = '$firstName $lastName'.trim();

    GetStorage().write(LocalStorageKeyStrings.userName, userName);
    // Update the Dio service with the new token
    service.updateAuthToken(loginResponse.accessToken ?? '');
  }
}
