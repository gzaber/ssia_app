part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class GetRoots extends HomePageEvent {
  const GetRoots();
}

class UpdateRootPosition extends HomePageEvent {
  final String parentId;
  final String id;
  final String name;
  final String description;
  final int position;
  final String iconName;

  const UpdateRootPosition({
    required this.parentId,
    required this.id,
    required this.name,
    required this.description,
    required this.position,
    required this.iconName,
  });
}
