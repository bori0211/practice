import 'package:flutter/material.dart';

import 'dart:async';

import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    bloc.fetchTopIds();

    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            print('ListView:${snapshot.data[index]}');
            return NewsListTile(
              itemId: snapshot.data[index],
            );
          },
        );
      },
    );
  }

  /*Widget buildList() {
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (BuildContext context, int index) {
        return FutureBuilder(
          future: getFuture(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Container(
              height: 80.0,
              child: snapshot.hasData ? Text('I am visible $index') : Text('You cant see me $index'),
            );
          },
        );
      },
    );
  }

  getFuture() {
    return Future.delayed(
      Duration(seconds: 2),
      () => 'hi',
    );
  }*/
}
