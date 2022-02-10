part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {
  const HomePageInitial();
}

class HomePageLoading extends HomePageState {
  const HomePageLoading();
}

class HomePageLoaded extends HomePageState {
  final List<Node> roots;

  const HomePageLoaded({required this.roots});
}

class HomePageUpdating extends HomePageState {
  const HomePageUpdating();
}

class HomePageUpdated extends HomePageState {
  final Node root;

  const HomePageUpdated({required this.root});
}

class HomePageError extends HomePageState {
  final String errMessage;

  const HomePageError({required this.errMessage});
}
