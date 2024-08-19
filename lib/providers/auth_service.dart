import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linexo_demo/pages/auth/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<void> saveUserLoggedInStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<bool> getUserLoggedInStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> removeUserLoggedInStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
  }

  Future<void> sendGuestLoginEmail(String email) async {
    try {
      User? user = (await _auth.fetchSignInMethodsForEmail(email)).isEmpty
          ? await _auth.createUserWithEmailAndPassword(email: email, password: "tempPassword123").then((result) => result.user)
          : await _auth.signInWithEmailAndPassword(email: email, password: "tempPassword123").then((result) => result.user);

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        await _auth.signOut();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: "tempPassword123",
      );

      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> isCurrentUserEmailVerified() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        user = _auth.currentUser;

        // Check Firestore for the 'verified' field
        DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(user!.uid).get();

        bool isVerifiedInFirestore = doc.exists ? (doc.data()?['verified'] ?? false) : false;

        // Return true if either the Firestore field or Firebase emailVerified is true
        return isVerifiedInFirestore || user.emailVerified;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isEmailVerified(String email) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: "tempPassword123",
      );

      User? user = userCredential.user;

      if (user != null && user.emailVerified) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'role': 'guest',
          'createdAt': Timestamp.now(),
        });

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await saveUserLoggedInStatus(true);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided for that user.';
        case 'invalid-email':
          return 'The email address is badly formatted.';
        default:
          return 'An unexpected error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  Future<String?> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signupUser(String email, String password, String kundennummer) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
      await _firestore.collection('kundennummer').doc(kundennummer).get();

      if (!doc.exists) {
        return "Ungültige Kundennummer";
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'kundennummer': kundennummer,
          'role': 'user',
          'createdAt': Timestamp.now(),
          'verified': true,  // Mark user as verified upon signup
        });

        await loginUser(email, password);
        return null;
      }
    } catch (e) {
      return e.toString();
    }
  }


  Future<void> logout(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final role = await getUserRole(user.uid);

        if (role == 'guest') {
          await _firestore.collection('users').doc(user.uid).delete();

          await user.delete();
        } else {
          await _auth.signOut();
        }
      } catch (e) {
        print('Error during logout: $e');
      } finally {
        await removeUserLoggedInStatus();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
              (route) => false,
        );
      }
    } else {
      await removeUserLoggedInStatus();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false,
      );
    }
  }

  Future<String?> getUserRole(String uid) async {

    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
      await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> fetchUserRole() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return doc.data()?['role'];
        }
        return null;
      }
      return null;
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  Future<void> deleteUser(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
      } catch (e) {
        print('Error deleting user: $e');
      } finally {
        await removeUserLoggedInStatus();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
              (route) => false,
        );
      }
    } else {
      print('No user is currently signed in');
    }
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          return doc.data();
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user  $e');
      return null;
    }
  }

  // Save general data
  Future<void> saveGeneralData(Map<String, dynamic> generalData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'general': generalData,
        });
      } catch (e) {
        throw Exception('Error saving general data: $e');
      }
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  // Save address data
  Future<void> saveAddressData(Map<String, dynamic> addressData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'address': addressData,
        });
      } catch (e) {
        throw Exception('Error saving address data: $e');
      }
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  // Save phone data
  Future<void> savePhoneData(Map<String, dynamic> phoneData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'phone': phoneData,
        });
      } catch (e) {
        throw Exception('Error saving phone data: $e');
      }
    } else {
      throw Exception('No user is currently signed in.');
    }
  }
}
