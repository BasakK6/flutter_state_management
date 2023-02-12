import 'package:logger/logger.dart';

class ProjectLogger {
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  //Singleton Pattern
  ProjectLogger._privateConstructor();

  static final ProjectLogger _instance = ProjectLogger._privateConstructor();

  factory ProjectLogger() {
    return _instance;
  }
}
