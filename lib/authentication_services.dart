import 'package:firebase_auth/firebase_auth.dart';
import 'AuthExceptionHandler.dart';

class AuthenticationService {
  final _auth = FirebaseAuth.instance;

//---------------------Register----------------
// Future<AuthStatus> createAccount({
//     required String email,
//     required String password,
//     required String name,
//   }) async {
//     try {
//       UserCredential newUser = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       _auth.currentUser!.updateDisplayName(name);
//       _status = AuthStatus.successful;
//     } on FirebaseAuthException catch (e) {
//       _status = AuthExceptionHandler.handleAuthException(e);
//     }
//     return _status;
//   }


// //---------------------Log in----------------
// Future<AuthStatus> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       _status = AuthStatus.successful;
//     } on  FirebaseAuthException catch (e) {
//       _status = AuthExceptionHandler.handleAuthException(e);
//     }
//     return _status;
//   }

//   //------------------Reset Pass--------------
//   Future<AuthStatus> resetPassword({required String email}) async {
//     await _auth
//         .sendPasswordResetEmail(email: email)
//         .then((value) => _status = AuthStatus.successful)
//         .catchError((e) => _status = AuthExceptionHandler.handleAuthException(e));
//     return _status;
//   }
  
}//AuthenticationService