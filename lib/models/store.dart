import 'package:wolie_mobile/models/user.dart';

class PassingArguments {
  final StoreUser storeUserModel;
  final StoreData storeDataModel;
  final StorePoint storePointModel;
  final UserData userDataModel;

  PassingArguments(
      {this.storeUserModel,
      this.storeDataModel,
      this.storePointModel,
      this.userDataModel});
}

class StoreData {
  final String title;
  final int wolieValue;
  final dynamic stampCardReward;
  final String area;
  final String imageUrl;
  final bool hasPickup;

  StoreData(
      {this.title,
      this.wolieValue,
      this.stampCardReward,
      this.area,
      this.imageUrl,
      this.hasPickup});
}

class StoreUser {
  final String email;
  final String uid;
  final String promoType;
  final String fromStore;
  final bool hasTables;
  final dynamic pointsReceived;
  final dynamic pointsGave;
  final dynamic coffeesGave;
  final dynamic coffeesTreated;

  StoreUser(
      {this.uid,
      this.promoType,
      this.email,
      this.fromStore,
      this.pointsGave,
      this.pointsReceived,
      this.coffeesGave,
      this.coffeesTreated,
      this.hasTables});
}

class StorePoint {
  String storeId;
  String name;
  bool hasPoints;
  dynamic totalPointsTraded;
  dynamic totalCoffeesTraded;
  dynamic points;
  dynamic totalCoffees;
  dynamic currentCoffeeNumber;
  dynamic storeReward;
  String imageUrl;

  StorePoint(
      {this.storeId,
      this.name,
      this.hasPoints,
      this.points,
      this.currentCoffeeNumber,
      this.totalCoffees,
      this.storeReward,
      this.imageUrl,
      this.totalPointsTraded,
      this.totalCoffeesTraded});
}
