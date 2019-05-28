import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final cities = ['서울', '강원', '대전', '충남', '세종', '충북', '인천', '경기', '광주', '전남', '전북', '부산', '경남', '울산', '제주', '대구', '경북'];
  final recentCities = ['서울', '경기', '부산'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        child: Card(
          color: Colors.red,
          /*shape: StadiumBorder(),*/
          child: Center(
            child: Text(query),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? recentCities : cities.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => ListTile(
            onTap: () {
              showResults(context);
            },
            leading: Icon(Icons.location_city),
            title: RichText(
              text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
      itemCount: suggestionList.length,
    );
  }
}
