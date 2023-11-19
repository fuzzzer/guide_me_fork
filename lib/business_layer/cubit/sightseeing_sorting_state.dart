part of 'sightseeing_sorting_cubit.dart';

sealed class SightseeingSortingState extends Equatable {
  const SightseeingSortingState();

  @override
  List<Object> get props => [];
}

final class SightseeingSortingInitial extends SightseeingSortingState {}

class SightseeingsortingLoading extends SightseeingSortingState {}

class SightseeingsortingLoaded extends SightseeingSortingState {
  final List<NearbyPlacesModel> sortedList;
  const SightseeingsortingLoaded(this.sortedList);
}
