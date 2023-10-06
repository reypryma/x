import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/constants/constants.dart';
import 'package:x/core/service_locator.dart';


final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(appwriteStorageProvider),
  );
});

abstract class StorageAPIInterface {
  Future<List<String>> uploadImage(List<File> files);
}

class StorageAPI implements StorageAPIInterface {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  @override
  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );

      imageLinks.add(
        AppwriteConstants.imageUrl(uploadedImage.$id),
      );
    }
    return imageLinks;
  }
}
