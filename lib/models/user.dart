class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String registrationDate;

  UserData({this.uid, this.name, this.registrationDate});
}

class UserRequest {
  final String name;
  final dynamic quantity;
  final String description;
  final String status;
  final String userId;
  final dynamic newCoffeeNumber;
  final dynamic newTotalCoffees;
  final dynamic newUserPoints;
  final String storeName;
  final dynamic storeReward;
  final String docId;
  final dynamic tableNumber;

  UserRequest(
      {this.name,
      this.quantity,
      this.description,
      this.status,
      this.userId,
      this.newCoffeeNumber,
      this.newTotalCoffees,
      this.storeName,
      this.newUserPoints,
      this.storeReward,
      this.docId,
      this.tableNumber});
}
