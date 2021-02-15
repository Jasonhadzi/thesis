import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wolie_mobile/models/milestone.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/models/user.dart';

class DatabaseService {
  final String uid;
  final String storeId;

  DatabaseService({this.uid, this.storeId});

  //collection reference for users
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUserData(
      {String name, String dateRegistered, String role}) async {
    return await userCollection.document(uid).setData(
        {'name': name, 'dateRegistered': dateRegistered, 'role': role});
  }

  Future addASuggestionInDB({String storeName}) async {
    await Firestore.instance
        .collection('store_suggestions')
        .document()
        .setData({
      'store': storeName,
      'from_user': uid,
    });
  }

  //collection reference for stores
  final CollectionReference storesCollection =
      Firestore.instance.collection('stores');

  //get store user stream
  Stream<StoreUser> get storeUser {
    return userCollection
        .document(storeId)
        .snapshots()
        .map(_storeUserFromSnapshot);
  }

  //map the doc snapshot to StoreUser object
  StoreUser _storeUserFromSnapshot(DocumentSnapshot doc) {
    return StoreUser(
        email: doc.data['email'] ?? '',
        coffeesGave: doc.data['coffees_gave'] ?? 0,
        coffeesTreated: doc.data['coffees_treated'] ?? 0,
        uid: storeId ?? '',
        fromStore: doc.data['from_store'] ?? '',
        pointsReceived: doc.data['points_received'] ?? 0,
        pointsGave: doc.data['points_gave'] ?? 0,
        promoType: doc.data['promo_type'] ?? '',
        hasTables: doc.data['has_tables'] ?? false);
  }

  Future updateStatusInDB({String docId, newValues}) async {
    return await storesCollection
        .document(storeId)
        .collection('requests')
        .document(docId)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  Future updateUsersRequestsData({UserRequest userRequest}) async {
    return await storesCollection
        .document(storeId)
        .collection('requests')
        .document()
        .setData({
      'name': userRequest.name,
      'quantity': userRequest.quantity,
      'description': userRequest.description,
      'status': userRequest.status,
      'uid': userRequest.userId,
      'store_reward': userRequest.storeReward,
      'store_name': userRequest.storeName,
      'new_coffee_number': userRequest.newCoffeeNumber,
      'new_total_coffees': userRequest.newTotalCoffees,
      'new_points': userRequest.newUserPoints,
      'table_number': userRequest.tableNumber,
    });
  }

  Stream<List<UserRequest>> get userRequests {
    return storesCollection
        .document(storeId)
        .collection('requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(_requestListFromSnapshot);
    //this returns a stream
  }

  //user request list from snapshot
  List<UserRequest> _requestListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserRequest(
        name: doc.data['name'] ?? '',
        quantity: doc.data['quantity'] ?? 0,
        description: doc.data['description'] ?? 0,
        status: doc.data['status'] ?? '',
        userId: doc.data['uid'] ?? '',
        docId: doc.documentID,
        storeReward: doc.data['store_reward'] ?? 0,
        storeName: doc.data['store_name'] ?? '',
        newCoffeeNumber: doc.data['new_coffee_number'] ?? 0,
        newTotalCoffees: doc.data['new_total_coffees'] ?? 0,
        newUserPoints: doc.data['new_points'] ?? 0,
        tableNumber: doc.data['table_number'] ?? 0,
      );
    }).toList();
  }

  //get stores stream

  Stream<List<StoreData>> get storeData {
    return storesCollection
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map(_storeDataFromSnapshot);
  }

  //storeData from snapshot
  List<StoreData> _storeDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return StoreData(
          title: doc.data['name'],
          wolieValue: doc.data['wolie_v'] ?? 0,
          stampCardReward: doc.data['stamp_card'] ?? 0,
          area: doc.data['area'] ?? '',
          imageUrl: doc.data['imageUrl'] ?? '',
          hasPickup: doc.data['has_pickup'] ?? false);
    }).toList();
  }
  //userData from snapshot

  //get user doc stream

  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        registrationDate: snapshot.data['dateRegistered']);
  }

  Stream<List<StorePoint>> get storesPoints {
    return userCollection
        .document(uid)
        .collection('stores')
        .snapshots()
        .map(_storePointListFromSnapshot);
  }

  //storepoint list from snapshot
  List<StorePoint> _storePointListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return StorePoint(
        storeId: doc.documentID ?? '',
        name: doc.data['name'] ?? '',
        hasPoints: doc.data['has_points'] ?? false,
        points: doc.data['points'] ?? 0.0,
        totalCoffees: doc.data['total_coffees'] ?? 0,
        currentCoffeeNumber: doc.data['current_coffee_number'] ?? 0,
        storeReward: doc.data['store_reward'] ?? 0,
        imageUrl: doc.data['imageUrl'] ?? '',
        totalPointsTraded: doc.data['total_points_traded'] ?? 0.0,
        totalCoffeesTraded: doc.data['total_coffees_traded'] ?? 0,
      );
    }).toList();
  }

  //get milestones stream
  Stream<List<Milestone>> get milestones {
    return storesCollection
        .document(storeId)
        .collection('milestones')
        .snapshots()
        .map(_milestoneListFromSnapshot);
  }

  //milestoneList from snapshot
  List<Milestone> _milestoneListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Milestone(
          milestoneName: doc.data['name'] ?? '',
          milestonePoints: doc.data['points'] ?? 0,
          milestoneType: doc.data['type'] ?? '');
    }).toList();
  }

  //////queries

  Future<bool> doesSpecificStoreWithCodeExist(
      {String collectionName, String storeCode}) async {
    final QuerySnapshot result = await Firestore.instance
        .collection(collectionName)
        .where('code', isEqualTo: storeCode)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }

  Future<bool> doesUserExist({String collectionName, String uid}) async {
    bool result;
    await Firestore.instance
        .collection(collectionName)
        .document(uid)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        if (doc.data['role'] == 'customer') {
          result = true;
        } else {
          result = false;
        }
      } else {
        result = false;
      }
    });

    return result;
  }

  Future<StorePoint> getFriendsStorePointData({String friendUid}) async {
    StorePoint storePointModel;
    await userCollection
        .document(friendUid)
        .collection('stores')
        .document(storeId)
        .get()
        .then((DocumentSnapshot doc) {
      storePointModel = StorePoint(
        storeId: doc.documentID ?? '',
        name: doc.data['name'] ?? '',
        hasPoints: doc.data['has_points'] ?? false,
        points: doc.data['points'] ?? 0.0,
        totalCoffees: doc.data['total_coffees'] ?? 0,
        currentCoffeeNumber: doc.data['current_coffee_number'] ?? 0,
        storeReward: doc.data['store_reward'] ?? 0,
        imageUrl: doc.data['imageUrl'] ?? '',
      );
    });

    return storePointModel;
  }

  Future<bool> checkIfUserHasStoreInSubCollection({String uidToCheck}) async {
    bool result;
    await userCollection
        .document(uidToCheck)
        .collection('stores')
        .document(storeId)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        result = true;
      } else {
        result = false;
      }
    });
    return result;
  }

  Future updateUserDataInDB(
      {String collectionName, selectedDoc, newValues}) async {
    return await Firestore.instance
        .collection(collectionName)
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  Future updateUserDataInSubCollection(
      {String collectionName,
      String subCollection,
      String subDocId,
      selectedDoc,
      newValues}) async {
    return await Firestore.instance
        .collection(collectionName)
        .document(selectedDoc)
        .collection(subCollection)
        .document(subDocId)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }
}
