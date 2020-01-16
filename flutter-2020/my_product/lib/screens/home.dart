import "package:flutter/material.dart";

import "../widgets/main_drawer.dart";

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Image.asset(
          "assets/images/flutter_home.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
