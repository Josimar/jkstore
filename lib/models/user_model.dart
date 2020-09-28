import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;
  bool isAdmin = false;

  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  void signUp({
    @required Map<String, dynamic> userData,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFailure}){

    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(email: userData["email"], password: pass).then((fireUser) async {
      firebaseUser = fireUser.user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFailure();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({
    @required String email,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFailure}) async{

    isLoading = true;
    notifyListeners();
    
    _auth.signInWithEmailAndPassword(email: email, password: pass)
        .then((fireUser) async {

          firebaseUser = fireUser.user;

          await _loadCurrentUser();

          onSuccess();
          isLoading = false;
          notifyListeners();
    }).catchError((e){
      // print("onComplete: Failed=" + e.toString());

      onFailure();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null){
      firebaseUser = await _auth.currentUser();
    }
    if (firebaseUser != null){
      if (userData["name"] == null){
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();

        userData = docUser.data;
      }

      isAdmin = await verifyPrivileges(firebaseUser);
    }
    notifyListeners();
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async {
    return await Firestore.instance.collection("admins").document(user.uid).get().then((doc){
      if (doc.data != null){
        return true;
      }else{
        return false;
      }
    }).catchError((e){
      return false;
    });
  }

}