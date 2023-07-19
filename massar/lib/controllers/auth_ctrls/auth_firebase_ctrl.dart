import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/utils/constants/firstore_constan.dart';
import 'package:project/utils/constants/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/chat_model/chat_user_model.dart';

class AuthFirebaseController extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences sharedPreferences;

  AuthFirebaseController(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.sharedPreferences});
  
  
  String getFirebaseUserId() {
    var userId = sharedPreferences.getString(FirestoreConstants.id);
    return userId ?? "noUser";
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  Future<User?> signUpController(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      await user?.updateProfile(displayName: name);
      await user?.reload();
      user = auth.currentUser;
      // print("user register successfully");
    } on FirebaseAuthException catch (err) {
      // print("error firebase Exception");
      if (err.code == 'weak-password') {
        snackBar(context, 'email already in use');
      } else if (err.code == 'email-already-in-use') {
        snackBar(context, "The account already exists for that email.");
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      notifyListeners();
    }
    return user;
  }

  Future<User?> loginController(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      debugPrint("Login successfully with firebase");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBar(context, 'user-not-found.');
      } else if (e.code == 'wrong-password') {
        snackBar(context, 'wrong password provided.');
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      notifyListeners();
    }
    return user;
  }

  Future<bool> handleLogin(String email, String password) async {
    try {
      User? firebaseUser = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (firebaseUser != null) {
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> document = result.docs;
        if (document.isEmpty) {
          firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(firebaseUser.uid)
              .set({
            FirestoreConstants.displayName: firebaseUser.displayName,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            FirestoreConstants.id: firebaseUser.uid,
            "createAt: ": DateTime.now().microsecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null
          });
          User? currentUser = firebaseUser;
          await sharedPreferences.setString(
              FirestoreConstants.id, currentUser.uid);
          await sharedPreferences.setString(
              FirestoreConstants.displayName, currentUser.displayName ?? "");
          await sharedPreferences.setString(
              FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
          await sharedPreferences.setString(
              FirestoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
        } else {
          DocumentSnapshot documentSnapshot = document[0];
          ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
          await sharedPreferences.setString(FirestoreConstants.id, userChat.id);
          await sharedPreferences.setString(
              FirestoreConstants.displayName, userChat.displayName);
          await sharedPreferences.setString(
              FirestoreConstants.aboutMe, userChat.aboutMe);
          await sharedPreferences.setString(
              FirestoreConstants.phoneNumber, userChat.phoneNumber);
        }
        debugPrint("Login with firebase successfully");
        return true;
      } else {
        debugPrint("Login fils");
        return false;
      }
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    } finally {
      notifyListeners();
    }
  }

  void signOuController() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  void verifyEmail() {
    user?.sendEmailVerification();
    notifyListeners();
  }

  Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await user.reload();
    User? refreshUser = auth.currentUser;
    return refreshUser;
  }


  
}
