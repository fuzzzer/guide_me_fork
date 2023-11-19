import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:guide_me/data_layer/httpClients/google_api_client.dart';

import '../../data_layer/models/nearby_places_model.dart';

part 'category_types_fetcher_state.dart';

class CategoryTypesFetcherCubit extends Cubit<CategoryTypesFetcherState> {
  CategoryTypesFetcherCubit() : super(CategoryTypesFetcherInitial());
  Future<void> fetchDataForCategories(List<NearbyPlacesModel> listOfPlaces,
      String category, GoogleApiClient googleApiClient) async {
    if (listOfPlaces.isEmpty) {
      try {
        emit(CategoryTypesFetcherLoading());
        final listOfFetchedPlaces = await googleApiClient
            .fetchDataForOtherCategories(listOfPlaces, category);

        if (isClosed) {
          return;
        }

        emit(CategoryTypesFetcherLoaded(listOfFetchedPlaces));
      } catch (error) {
        // Handle the error here
        emit(
            CategoryTypesFetcherError('Failed to fetch nearby places: $error'));
      }
    }
  }
}
