import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;
    print(1);
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSignedIn());
      print(2);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthFailure(messege: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthFailure(messege: 'Wrong password provided for that user.'));
      } else {
        emit(AuthFailure(messege: e.toString()));
      }
    }
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "userID": userCredential.user!.uid,
        "userName": username,
        "email": email
      });
      userCredential.user!.updateDisplayName(username);
      emit(AuthSignedUp());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFailure(messege: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(
            AuthFailure(messege: 'The account already exists for that email.'));
      } else {
        emit(AuthFailure(messege: e.toString()));
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
