import 'package:logger/logger.dart';

class ProjectLogger {
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  //Singleton Pattern
  ProjectLogger._private_constuctor();

  static final ProjectLogger _instance = ProjectLogger._private_constuctor();

  factory ProjectLogger() {
    return _instance;
  }
}
