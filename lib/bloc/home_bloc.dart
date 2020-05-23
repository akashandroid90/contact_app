import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/state/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeState, HomeState> {
  @override
  // TODO: implement initialState
  HomeState get initialState => HomeState(
      screen: ScreenConstants.CONTACT_LIST_SCREEN,
      title: StringConstants.CONTACT_LIST);

  @override
  Stream<HomeState> mapEventToState(event) async* {
    yield event;
  }

  void updateTitle(String title) {
    add(HomeState(screen: state.screen, title: title));
  }

  void updateScreen(String screen) {
    add(HomeState(
        screen: ScreenConstants.CONTACT_LIST_SCREEN, title: state.title));
  }

  void updateData(String screen, String title) {
    add(HomeState(title: title, screen: screen));
  }
}
