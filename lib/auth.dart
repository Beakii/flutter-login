import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Global Variable Storeage for GoogleSignIn's
GoogleSignIn _user;
GoogleSignInAccount _gUser;
FirebaseUser loggedInUser;

//Abstracting the Auth class to allow for use of these methods in other .dart files.
abstract class BaseAuth{
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> signInWithGoogle(GoogleSignIn info);
  Future<String> currentUser();
  Future<void> signOut();
}

//Firebase authentication for email/password and Google SignIn's and Outs.
class Auth implements BaseAuth{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<String> get onAuthStateChanged{
    return _firebaseAuth.onAuthStateChanged.map((user) => user?.uid);
  }

//Firebase SignIn with Email/Password
  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    loggedInUser = user;
    return user.uid;
  }

//Firebase Create-user with Email/Password
  @override
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    loggedInUser = user;
    return user.uid;
  }

//Google SignIn through Firebase
//Must use FirebaseAuth.instance.signInWithCredentials
  @override
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
    return _gUser.id;
  }

//Returns the current logged in user
  @override
  Future<String> currentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

//Sign's out of Google and Firebase
  @override
  Future<void> signOut() async{
    _firebaseAuth.signOut();
  }
}