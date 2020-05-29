import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/state/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeState, HomeState> {
  @override
  HomeState get initialState =>
      HomeState(screen: ScreenConstants.CONTACT_LIST_SCREEN);

  @override
  Stream<HomeState> mapEventToState(event) async* {
    yield event;
  }

  void updateScreen(String screen) {
    add(HomeState(screen: screen));
  }
}
