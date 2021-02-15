import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/customer/request_tile.dart';

class RequestList extends StatefulWidget {
  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<List<UserRequest>>(context) ?? [];

    //print(requests.documents);

    requests.forEach((request) {
      print(request.name);
      print(request.status);
      print(request.quantity);
      print(request.description);
    });

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        return RequestTile(request: requests[index]);
      },
    );
  }
}
