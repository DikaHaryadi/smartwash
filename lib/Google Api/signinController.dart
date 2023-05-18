// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mobile/Google%20Api/model_user.dart';

// class SignInController extends GetxController {
//   SignInController();
//   final state = SignInController();

//   final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['openid']);

//   Future<void> handleSignIn(String type) async {
//     try {
//       if (type == "phone number") {
//         if (kDebugMode) {
//           print('...you are loggin in with phone number ..');
//         }
//       } else if (type == "google") {
//         var user = await _googleSignIn.signIn();
//         if (user != null) {
//           String? displayName = user.displayName;
//           String email = user.email;
//           // String id = user.id;
//           String photoUrl = user.photoUrl ?? 'assets/images/logo2.png';
//           LoginRequestEntity loginRequestEntity = LoginRequestEntity();
//           loginRequestEntity.imageProfile = photoUrl;
//           loginRequestEntity.name = displayName;
//           loginRequestEntity.email = email;
//         }
//       } else {
//         if (kDebugMode) {
//           print('...login type not sure..');
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('...error with login $e');
//       }
//     }
//   }
// }
