
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final ggAuth = await googleSignInAccount!.authentication;

      // print("=============");
      // log(ggAuth.idToken.toString());
      // log(ggAuth.accessToken.toString());
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      // print("///" + credential.token.toString());
      // print("///" + credential.toString());
      await _auth.signInWithCredential(credential);
      return ggAuth.idToken!;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("/////" + e.message.toString());
      }
      // throw e;
    }
    return null;
  }

  Future<void> signOutFromGoogle() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}