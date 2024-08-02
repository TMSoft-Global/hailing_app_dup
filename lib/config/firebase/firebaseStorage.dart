import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

enum FirebaseStorageContentType { image, video }

abstract class _BaseDatabase {
  Future<String> uploadFileToStorage();
  Future<String> uploadbytesToStorage();
  Future<void> deleteStorage(String url);
}

class FireStorage implements _BaseDatabase {
  @override
  Future<String> uploadFileToStorage({
    String? path,
    String? destinationFolderName,
  }) async {
    String? url;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("$destinationFolderName/$fileName");
    UploadTask uploadTask = reference.putFile(File(path!));
    await uploadTask.then((TaskSnapshot snapshot) async {
      url = await snapshot.ref.getDownloadURL();
    });
    return url!;
  }

  // use this for progress showing
  
  // uploadTask.snapshotEvents.listen((event) {
  //       setState(() {
  //         _progress =
  //             event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
  //         print(_progress.toString());
  //       });
  //       if (event.state == TaskState.success) {
  //         _progress = null;
  //         Fluttertoast.showToast(msg: 'File added to the library');
  //       }
  //     }).onError((error) {
  //       // do something to handle error
  // });

  @override
  Future<String> uploadbytesToStorage({
    @required Uint8List? bytes,
    @required String? destinationFolderName,
    @required FirebaseStorageContentType? contentType,
  }) async {
    String? url;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("$destinationFolderName/$fileName");
        
    UploadTask uploadTask = reference.putData(
      bytes!,
      SettableMetadata(
        contentType: contentType == FirebaseStorageContentType.image
            ? 'image/jpeg'
            : 'video/mp4',
      ),
    );
    await uploadTask.then((TaskSnapshot snapshot) async {
      url = await snapshot.ref.getDownloadURL();
    });
    return url!;
  }

  @override
  Future<void> deleteStorage(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
    } catch (e) {
      log(e.toString());
    }
  }
}
