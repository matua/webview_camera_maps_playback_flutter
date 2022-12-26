import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'favoriteUrlsList.g.dart';

@riverpod
class FavoriteUrls extends _$FavoriteUrls {
  List<String> list = List<String>.empty(growable: true);

  @override
  List<String> build() {
    return <String>["https://www.skillbox.ru"];
  }

  List<String> addToList(String url) {
    if (!list.contains(url)) {
      list.add(url);
    }
    return list;
  }

  List<String> removeFromList(String url) {
    if (list.contains(url)) {
      list.remove(url);
    }
    return list;
  }
}
