import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guide_me/data_layer/httpClients/google_api_client.dart';

import '../../data_layer/models/nearby_places_model.dart';

part 'fetch_searched_items_state.dart';

class FetchSearchedItemsCubit extends Cubit<FetchSearchedItemsState> {
  FetchSearchedItemsCubit() : super(FetchSearchedItemsInitial());
  Future<void> searchListFetcher(
      String nameOfPlace,
      List<NearbyPlacesModel> listOfSearched,
      GoogleApiClient googleApiClient) async {
    try {
      emit(FetchSearchedItemsLoading());
      final listOfFetchedSearches = await googleApiClient.fetchForSearchList(
        nameOfPlace,
        listOfSearched,
      );

      if (isClosed) {
        return;
      }

      emit(FetchSearchedItemsLoaded(listOfFetchedSearches));
    } catch (error) {
      // Handle the error here
      emit(FetchSearchedItemsError('Failed to fetch nearby places: $error'));
    }
  }
}
