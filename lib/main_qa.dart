import 'environment_config/app_loader.dart';
import 'environment_config/env_paths.dart';

void main() async {
  AppLoader appLoader = AppLoader();
  appLoader.loadApp(EnvPaths.path_qa);
}