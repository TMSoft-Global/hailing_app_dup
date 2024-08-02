// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:pickme_mobile/config/checkSession.dart';
// import 'package:pickme_mobile/main.dart';

// abstract class _BaseDatabase {
//   Future<String> saveRecord();
//   Future<String> setRecordSyncing();
//   Future<String> deleteRecord();
//   Future<String> deleteSyncRecord();
// }

// class FirebaseService implements _BaseDatabase {
//   final _recordRef = FirebaseDatabase.instanceFor(app: firebaseApp!)
//       .ref()
//       .child("StudentID");
//   final _syncRecordRef = FirebaseDatabase.instanceFor(app: firebaseApp!)
//       .ref()
//       .child("SyncRecords");

//   @override
//   Future<String> saveRecord({
//     @required Map<String, dynamic>? meta,
//   }) async {
//     try {
//       await _recordRef.child(userModel!.data!.user!.schoolDetials!.schoolCode!).push().set({
//         ...meta!,
//         "createDate": DateTime.now().toIso8601String().split("T")[0],
//         "createAt": DateTime.now().millisecondsSinceEpoch,
//         "createUser": userModel!.data!.user!.id,
//         "updateUser": userModel!.data!.user!.id,
//         "schoolCode": userModel!.data!.user!.schoolDetials!.schoolCode!,
//         "updateAt": DateTime.now().millisecondsSinceEpoch,
//         "deleted": false,
//       });
//       return "success";
//     } on PlatformException catch (error) {
//       if (kDebugMode) {
//         print(error);
//       }
//       return error.message!;
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       return e.toString();
//     }
//   }

//   @override
//   Future<String> setRecordSyncing({
//     @required String? key,
//     bool status = true,
//   }) async {
//     try {
//       await _recordRef.child(key!).update({"isSyncing": status});
//       return "success";
//     } on PlatformException catch (error) {
//       if (kDebugMode) {
//         print(error);
//       }
//       return error.message!;
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       return e.toString();
//     }
//   }

//   @override
//   Future<String> deleteRecord({
//     @required Map<String, dynamic>? meta,
//     @required String? key,
//     @required String? healthStaffId,
//   }) async {
//     try {
//       await _syncRecordRef
//           .child("${DateTime.now().toIso8601String().split("T")[0]}")
//           .child(healthStaffId!)
//           .update({...meta!});
//       await _recordRef.child(key!).remove();
//       return "success";
//     } on PlatformException catch (error) {
//       if (kDebugMode) {
//         print(error);
//       }
//       return error.message!;
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       return e.toString();
//     }
//   }

//   @override
//   Future<String> deleteSyncRecord({
//     @required String? date,
//     @required String? childId,
//   }) async {
//     try {
//       await _syncRecordRef.child("$date").child("$childId").remove();
//       return "success";
//     } on PlatformException catch (error) {
//       if (kDebugMode) {
//         print(error);
//       }
//       return error.message!;
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       return e.toString();
//     }
//   }
// }
