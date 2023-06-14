import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  final CollectionReference userColRef =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupColRef =
      FirebaseFirestore.instance.collection("groups");

  // Update user data
  Future updateUserData(
      String fullName, String email,String college) async {
    return await userColRef.doc(uid).set({
      "fullName":fullName,
      "email":email,
      "college":college,
      "groups":[],
      "uid":uid,
    }
    );
  }
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userColRef.where("email", isEqualTo: email).get();
    return snapshot;
  }

}
