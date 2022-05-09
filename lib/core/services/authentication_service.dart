import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<List<String>> createUser(String emailAddress, String password,
      String name, String username, String phone, String upi) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ['The password provided is too weak.'];
      } else if (e.code == 'email-already-in-use') {
        return ['The account already exists for that email.'];
      }
    } catch (e) {
      return [e.toString()];
    }

    return ['Success', credential!.user!.uid];
  }

  Future<String> loginUser(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'Success';
  }

  Future<String> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on Exception catch (e) {
      return e.toString();
    }
    return 'Success';
  }

  String? getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}
