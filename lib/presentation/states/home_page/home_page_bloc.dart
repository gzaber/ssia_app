import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/viewmodels/home_page_viewmodel.dart';
import 'package:equatable/equatable.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final HomePageViewModel _viewModel;

  HomePageBloc(this._viewModel) : super(HomePageInitial());

  void getRoots() => add(GetRoots());

  @override
  Stream<HomePageState> mapEventToState(
    HomePageEvent event,
  ) async* {
    if (event is GetRoots) {
      try {
        yield HomePageLoading();
        await _viewModel.getRoots();
        yield HomePageLoaded(roots: _viewModel.roots);
      } on Error catch (e) {
        yield HomePageError(errMessage: e.toString());
      } on Exception catch (e) {
        yield HomePageError(errMessage: e.toString());
      }
    }
    if (event is UpdateRootPosition) {
      try {
        yield HomePageUpdating();
        await _viewModel.updateNodePosition(
          event.parentId,
          event.id,
          event.name,
          event.description,
          event.position,
          event.iconName,
        );
        yield HomePageUpdated(root: _viewModel.root);
      } on Error catch (e) {
        yield HomePageError(errMessage: e.toString());
      } on Exception catch (e) {
        yield HomePageError(errMessage: e.toString());
      }
    }
  }
}
