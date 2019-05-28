import 'dart:ui';

class Chapter {
  String chapterName;
  String chapterQuestions;
  int color1, color2;

  Chapter({this.chapterName, this.chapterQuestions, this.color1, this.color2});

  static List<Chapter> chapterList() {
    var listOfChapter = new List<Chapter>();

    listOfChapter.add(new Chapter(chapterName: '111', chapterQuestions: 'Question 1111', color1: 0x001122, color2: 0x331122));
    listOfChapter.add(new Chapter(chapterName: '222', chapterQuestions: 'Question 2222', color1: 0x001122, color2: 0x331122));

    return listOfChapter;
  }
}
