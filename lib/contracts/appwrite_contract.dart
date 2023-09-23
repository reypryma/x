import 'package:appwrite/appwrite.dart';

abstract class AppwriteServiceContract {
  Client init();
}

class AppWriteService implements AppwriteServiceContract {
  late Client client;

  AppWriteService() {
    client = Client()
        .setEndpoint('http://127.0.0.1:885/v1')
        .setProject('650aa6c4a35400770ff0');
  }

  @override
  Client init() {
    return client;
  }
}
