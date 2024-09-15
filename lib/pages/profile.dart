import 'package:flutter/material.dart';
import 'package:flutter_jo/shared/shared.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: Column(
        children: [
          Text("ID ${userModelData!.id}"),
          Text("Name ${userModelData!.name}"),
        ],
      ),
    );
  }
}
