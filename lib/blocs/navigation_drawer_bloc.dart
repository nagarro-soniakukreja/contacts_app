import 'dart:async';

class NavigationDrawerBloc {
  final navigationController = StreamController();
  final navigationTitleController = StreamController();
  NavigationProvider navigationProvider = new NavigationProvider();

  Stream get getNavigation => navigationController.stream;
  Stream get getNavigationTitle => navigationTitleController.stream;

  void updateNavigation(String navigation) {
    navigationProvider.updateNavigation(navigation);
    navigationController.sink.add(navigationProvider
        .currentNavigation);
  }

  void updateNavigationTitle(String title) {
    navigationTitleController.sink.add(title);
  }

  void dispose() {
    navigationController
        .close();
    navigationTitleController.close();
  }
}

final navigationBloc = NavigationDrawerBloc();

class NavigationProvider {
  String currentNavigation = "Contact List";

  void updateNavigation(String nav){
    currentNavigation = nav;
  }
}