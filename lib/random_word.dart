import 'package:english_words/english_words.dart';

class RandomWords {
  final _wordList = List<String>();
  
  List<String> fillList(){
    for (var i = 0; i < 100; i++) {
      final _word = WordPair.random().asPascalCase;
      _wordList.add(_word);
    }

    return _wordList;
  }
}
