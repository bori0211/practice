import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (BuildContext context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        print(snapshot.hasData);
        if (!snapshot.hasData) {
          return Text('Stream still loading');
        }

        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (BuildContext context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('Stream still item $itemId');
            }
            return Text(itemSnapshot.data.title);
          },
        );
      },
    );
  }
}
