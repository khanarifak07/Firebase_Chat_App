import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //create auth and firestore instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //login
  Future<String?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      //login user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      //save user info in saperate doc if not exists
      _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      //return null if login is success
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occured while login";
      //handle specific error cases
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect Password';
          break;
        //default
        default:
          errorMessage = 'Error: ${e.message}';
      }
      return errorMessage;
    }
  }

  //singup
  Future<String?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      //sing up user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      //save user info in a saperate document
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      // Return null if sign up is successful
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred while signing up.';

      // Handle specific error cases
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              'The email address is already in use by another account.';
          break;
        case 'weak-password':
          errorMessage = 'Password should be at least 6 characters';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'ERROR_INVALID_EMAIL':
          errorMessage = 'Invalid Email';
          break;
        // Handle other Firebase authentication errors as needed
        default:
          errorMessage = 'Error: ${e.message}';
      }
      // Return the error message
      return errorMessage;
    }
  }

  //logout
  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}
