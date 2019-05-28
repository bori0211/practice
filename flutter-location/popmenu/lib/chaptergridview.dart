import 'package:flutter/material.dart';
import 'chapter.dart';
//import 'menuitem.dart';

class ChapterGridView extends StatelessWidget {
  final List<Chapter> allChapters;

  ChapterGridView({Key key, this.allChapters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 0.9,
      children: _getGridViewItems(context),
    );
  }

  _getGridViewItems(BuildContext context) {
    List<Widget> chapterWidgets = new List<Widget>();

    for (int i = 0; i < allChapters.length; i++) {
      var widget = _getGridViewItemUI(context, allChapters[i]);
      chapterWidgets.add(widget);
    }

    return chapterWidgets;
  }

  _getGridViewItemUI(BuildContext context, Chapter item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [new Color(item.color1), new Color(item.color2)],
            begin: Alignment.centerRight,
            end: new Alignment(-1.0, -1.0),
          ),
        ),
      ),
    );
  }
}
