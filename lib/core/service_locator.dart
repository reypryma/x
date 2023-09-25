import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:x/constants/appwrite_constants.dart';
import 'package:x/contracts/appwrite_contract.dart';

GetIt injector = GetIt.instance;

Future setUpDependencies() async {
  injector
      .registerLazySingleton<AppwriteServiceContract>(() => AppWriteService());
}

final appWriteService = injector.get<AppwriteServiceContract>();

final appWriteClientProvider = Provider((ref) => Client()
    .setEndpoint(AppwriteConstants.endPoint)
    .setProject(AppwriteConstants.projectId)
    .setSelfSigned(status: true));

// watch is continiously, read is for once
final appWriteAccountProvider =
    Provider((ref) => Account(ref.watch(appWriteClientProvider)));


final appwriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Databases(client);
});