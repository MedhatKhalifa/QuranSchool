// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';


// class OnlineStatusManager {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final DatabaseReference _realtimeDb = FirebaseDatabase.instance.reference();
//   late User _currentUser;

//   void init() {
//     _auth.authStateChanges().listen((User? user) {
//       if (user != null) {
//         _currentUser = user;
//         _updateStatus(true);
//         _listenToConnectionChanges();
//       } else {
//         _updateStatus(false);
//       }
//     });
//   }

//   void _listenToConnectionChanges() {
//     _realtimeDb.child('.info/connected').onValue.listen((event) {
//       final connected = event.snapshot.value as bool? ?? false;
//       if (connected) {
//         _updateStatus(true);
//         _setupOnDisconnect();
//       } else {
//         _updateStatus(false);
//       }
//     });
//   }

//   void _setupOnDisconnect() {
//     _realtimeDb.child('status/${_currentUser.uid}').onDisconnect().set({
//       'isOnline': false,
//       'lastSeen': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> _updateStatus(bool isOnline) async {
//     await _realtimeDb.child('status/${_currentUser.uid}').set({
//       'isOnline': isOnline,
//       'lastSeen': FieldValue.serverTimestamp(),
//     });
//     await _firestore.collection('status').doc(_currentUser.uid).set({
//       'isOnline': isOnline,
//       'lastSeen': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> setUserOffline() async {
//     await _realtimeDb.child('status/${_currentUser.uid}').set({
//       'isOnline': false,
//       'lastSeen': FieldValue.serverTimestamp(),
//     });
//     await _firestore.collection('status').doc(_currentUser.uid).set({
//       'isOnline': false,
//       'lastSeen': FieldValue.serverTimestamp(),
//     });
//   }
// }

// // Initialize in your main function or any initialization code
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   OnlineStatusManager().init();
//   runApp(MyApp());
// }
