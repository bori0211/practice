import "package:flutter/material.dart";

import "./screens/home.dart";
import "./screens/product_list.dart";
import "./screens/product_view.dart";
import "./screens/product_form.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: HomeScreen(),
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/product": (context) => ProductListScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split("/"); // '/product/view/1'

        if (pathElements[0] == "" && pathElements[1] == "product") {
          if (pathElements[2] == "view") {
            //print("view:" + pathElements[3]);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductViewScreen(int.parse(pathElements[3])),
            );
          }
          if (pathElements[2] == "new") {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductFormScreen("new", null),
            );
          }
          if (pathElements[2] == "modify") {
            //print('modify:' + pathElements[2]);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductFormScreen("modify", int.parse(pathElements[3])),
            );
          }
        }
        return null;
      },
    );
  }
}
