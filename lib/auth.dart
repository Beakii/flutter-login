import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Global Variable Storeage for GoogleSignIn's
GoogleSignIn _user;
GoogleSignInAccount _gUser;

//Abstracting the Auth class to allow for use of these methods in other .dart files.
abstract class BaseAuth{
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<void>signInWithGoogle(GoogleSignIn info);
  Future<String> currentUser();
  Future<void> signOut();
}

//Firebase authentication for email/password and Google SignIn's and Outs.
class Auth implements BaseAuth{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//Firebase SignIn with Email/Password
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

//Firebase Create-user with Email/Password
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

//Google SignIn through Firebase
//Must use FirebaseAuth.instance.signInWithCredentials
  Future<String> signInWithGoogle(GoogleSignIn info) async{
    _user = info;
    _gUser = await info.signIn();
    GoogleSignInAuthentication googleAuth = await _gUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    final FirebaseUser fbUser = await _firebaseAuth.signInWithCredential(credential);

    assert(_gUser.email != null);
    assert(_gUser.displayName != null);
    assert(!fbUser.isAnonymous);
    assert(await fbUser.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(fbUser.uid == currentUser.uid);
  }

//Returns the current logged in user
  Future<String> currentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

//Sign's out of Google and Firebase
  Future<void> signOut() async{
    _user.signOut();
    return _firebaseAuth.signOut();
  }
}