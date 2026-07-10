import 'package:flutter_dotenv/flutter_dotenv.dart';

DotEnv dotEnv = DotEnv();
class EnvironmentConfiguration {
  static var baseUrlApi = dotEnv.env['BASE_URL_API'];
  static var faceUrlApi = dotEnv.env['FACE_URL_API'];
  static var taskUrlApi = dotEnv.env['TASK_BASE_URL'];
  static var faceMatchingUrl = dotEnv.env['FACE_MATCHING_BACE_URL'];
  static var amplitudeApiKey = dotEnv.env['AMPLITUDE_API_KEY'];
}
