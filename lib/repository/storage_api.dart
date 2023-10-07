import 'dart:io';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
    var endpoint = AppwriteConstants.endPointMobile;

    if(kIsWeb){
      print('UploadImage using web');
      endpoint = AppwriteConstants.endPointWeb;
      for (final fileWeb in files) {
        XFile file = XFile(fileWeb.path);
        List<int> fileBytes = await file.readAsBytes();

        // Parse the URL and extract the path
        Uri uri = Uri.parse(file.path.replaceFirst("blob:", ""));
        String filename = uri.pathSegments.last;

        final uploadedImage = await _storage.createFile(
          bucketId: AppwriteConstants.imagesBucket,
          fileId: ID.unique(),
          file: InputFile.fromBytes(
            bytes: fileBytes,
            filename: filename,
          ),
        );

        imageLinks.add(
          AppwriteConstants.imageUrl(uploadedImage.$id, endpoint),
        );
      }

      return imageLinks;
    }

    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );

      imageLinks.add(
        AppwriteConstants.imageUrl(uploadedImage.$id, endpoint),
      );
    }
    return imageLinks;
  }
}
