import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guide_me/business_layer/cubits.dart';
import 'package:guide_me/data_layer/data.dart';
import 'package:guide_me/data_layer/models/nearby_places_model.dart';
import 'package:guide_me/main.dart';

import 'package:http/http.dart' as http;

// this client is responsible for all the operations connected with google_places_api and google_maps api, has methods associated with
// data from those clients

class GoogleApiClient {
  String apiKey = dotenv.env['GOOGLE_API_KEY']!;
  Future<List<String>> fetChPhotosHelper(
      List<String> listOfPhotos, String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          final List<dynamic>? photos = data['result']['photos'];
          if (photos != null && photos.isNotEmpty) {
            List<String> photoUrls = [];
            for (var photo in photos) {
              final photoReference = photo['photo_reference'];
              const maxWidth = 1000;
              try {
                final photoUrl = Uri.parse(
                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photoreference=$photoReference&key=$apiKey');
                photoUrls.add(photoUrl.toString());
              } on Exception {
                rethrow;
              }
            }
            return photoUrls;
          } else {
            return [];
          }
        } on Exception {
          rethrow;
        }
      } else {
        // Handle the error if the request was not successful.

        throw Exception('Failed to fetch photos');
      }
    } on Exception {
      rethrow;
    }
  }

  Future<List<NearbyPlacesModel>> fetchForSearchList(
    String nameOfPlace,
    List<NearbyPlacesModel> listOfSearchedItems,
  ) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$nameOfPlace&key=$apiKey');

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Successful request, parse the JSON.
          try {
            final jsonData = json.decode(response.body);
            final places = jsonData['results'];

            // print(places);
            for (var placeData in places) {
              var place = NearbyPlacesModel.fromJason(placeData);
              if (place.vicinity != 'Tbilisi') {
                listOfSearchedItems.add(place);
              }
            }
          } on Exception catch (e) {
            throw Exception(e);
          }

          return listOfSearchedItems;
        } else {
          throw Exception('Failed to fetch nearby sightseeing places');
        }
      } on Exception catch (e) {
        throw Exception(e);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<List<NearbyPlacesModel>> fetchDataForOtherCategories(
      List<NearbyPlacesModel> listOfPlaces, String category) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$category&key=$apiKey');
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Successful request, parse the JSON.
          try {
            final jsonData = json.decode(response.body);
            final places = jsonData['results'];
            for (var placeData in places) {
              var place = NearbyPlacesModel.fromJason(placeData);
              if (place.vicinity != 'Tbilisi') {
                listOfPlaces.add(place);
              }
            }
          } on Exception catch (e) {
            throw Exception(e);
          }

          return listOfPlaces;
          // Continue with JSON parsing.
        } else {
          // Handle the error if the request was not successful.

          throw Exception('Failed to fetch nearby places');
        }
      } on Exception catch (e) {
        throw Exception(e);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<List<NearbyPlacesModel>> fetchData(
    List<NearbyPlacesModel> listOfPlaces,
  ) async {
    final UserLocation userLocation = sl.sl.get<UserLocation>();
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${userLocation.userLat},${userLocation.userLon}&radius=8000&type=park|museum&key=$apiKey');

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Successful request, parse the JSON.
          try {
            final jsonData = json.decode(response.body);
            final places = jsonData['results'];
            for (var placeData in places) {
              var place = NearbyPlacesModel.fromJason(placeData);
              if (place.vicinity != 'Tbilisi') {
                listOfPlaces.add(place);
              }
            }
          } on Exception catch (e) {
            throw Exception(e);
          }

          return listOfPlaces;
          // Continue with JSON parsing.
        } else {
          // Handle the error if the request was not successful.

          throw Exception('Failed to fetch nearby places');
        }
      } on Exception catch (e) {
        throw Exception(e);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<List<NearbyPlacesModel>> fetchSightseeingData(
    List<NearbyPlacesModel> listOfSightseeingPlaces,
  ) async {
    final UserLocation userLocation = sl.sl.get<UserLocation>();
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${userLocation.userLat},${userLocation.userLon}&radius=8000&type=hotel|food&key=$apiKey');

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Successful request, parse the JSON.
          try {
            final jsonData = json.decode(response.body);
            final places = jsonData['results'];
            for (var placeData in places) {
              var place = NearbyPlacesModel.fromJason(placeData);
              if (place.vicinity != 'Tbilisi') {
                listOfSightseeingPlaces.add(place);
              }
            }
          } on Exception catch (e) {
            throw Exception(e);
          }

          return listOfSightseeingPlaces;
          // Continue with JSON parsing.
        } else {
          // Handle the error if the request was not successful.

          throw Exception('Failed to fetch nearby sightseeing places');
        }
      } on Exception catch (e) {
        throw Exception(e);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<List<NearbyPlacesModel>> fetchPlacesForFoodData(
    List<NearbyPlacesModel> listPlacesForFood,
  ) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=bar+food&key=$apiKey');

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Successful request, parse the JSON.
          try {
            final jsonData = json.decode(response.body);
            final places = jsonData['results'];

            // print(places);
            for (var placeData in places) {
              var place = NearbyPlacesModel.fromJason(placeData);
              if (place.vicinity != 'Tbilisi') {
                listPlacesForFood.add(place);
              }
            }
          } on Exception catch (e) {
            throw Exception(e);
          }

          return listPlacesForFood;
          // Continue with JSON parsing.
        } else {
          // Handle the error if the request was not successful.

          throw Exception('Failed to fetch nearby sightseeing places');
        }
      } on Exception catch (e) {
        throw Exception(e);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String?, String?>> fetchDetails(String placeId) async {
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);

          if (data['status'] == 'OK') {
            final phoneNumber =
                data['result']['formatted_phone_number'] ?? 'No Number';

            final formattedAdress =
                data['result']['formatted_address'] ?? 'No Address';

            final periods = data['result']["current_opening_hours"]?["periods"];
            String openTime;
            String closeTime;
            if (periods != null && periods.isNotEmpty) {
              openTime = periods[0]["open"]["time"] ?? "No Information";
              closeTime = periods[0]["close"]["time"] ?? "No Information";
            } else {
              openTime = "N/a N/a";
              closeTime = "N/a N/a";
            }

            return {
              'phone': phoneNumber,
              'adress': formattedAdress,
              'open_hour': openTime,
              'close_hour': closeTime
            };
          } else {
            throw ('Data status != ok');
          }
        } on Exception catch (e) {
          throw Exception(e);
        }
      } else {
        throw ('Failed to fetch');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> createMap(
      Map<String, List<NearbyPlacesModel>> cachedData,
      String category,
      CategoryTypesFetcherCubit categoryTypesFetcherCubit,
      List<NearbyPlacesModel> listOfPlaces,
      Completer<String> mapLoaderController) async {
    if (!cachedData.containsKey(
      category,
    )) {
      categoryTypesFetcherCubit.fetchDataForCategories(
          listOfPlaces, category, sl.sl<GoogleApiClient>());
      cachedData[category] = listOfPlaces;
    }
    if (cachedData[category]!.isNotEmpty) {
      mapLoaderController.complete('Completed');
    }
  }

  void createLists(List<MapItem> firstList, List<MapItem> secondList,
      List<String> categoryList) {
    categoryList.add('grocery');
    categoryList.add('mall');
    categoryList.add('hospital');
    categoryList.add('park');
    firstList.add(MapItem(
        icon: const Icon(
          Icons.fort_outlined,
          color: Color(0xffF4C871),
        ),
        color: const Color(0xffF4C871),
        textLabel: 'sights'));
    firstList.add(MapItem(
        icon: const Icon(
          Icons.hotel,
          color: Color(
            0xffA3C3DB,
          ),
        ),
        color: const Color(
          0xffA3C3DB,
        ),
        textLabel: 'hotels'));
    firstList.add(MapItem(
        icon: const Icon(
          Icons.nightlife,
          color: Color(0xffC75E6B),
        ),
        color: const Color(0xffC75E6B),
        textLabel: 'nightLife'));
    secondList.add(MapItem(
        icon: const Icon(
          Icons.restaurant,
          color: Color(0xffC2807E),
        ),
        color: const Color(0xffC2807E),
        textLabel: 'restaurants'));
    secondList.add(MapItem(
        icon: Image.asset('assets/images/Other.png',
            color: const Color(0xffF3F0E6)),
        color: const Color(0xffF3F0E6),
        textLabel: 'other'));
  }

  Future<void> createList(
      Map<NearbyPlacesModel, double?> distanceMap,
      String category,
      CategoryTypesFetcherCubit categoryTypesFetcherCubit,
      List<NearbyPlacesModel> listOfPlaces,
      Completer<String> listLoaderController) async {
    if (listOfPlaces.isEmpty) {
      await categoryTypesFetcherCubit.fetchDataForCategories(
          listOfPlaces, category, sl.sl<GoogleApiClient>());
      createDistanceMap(
        distanceMap,
        listOfPlaces,
      );
      listLoaderController.complete('Completed');
    }
    if (listOfPlaces.isNotEmpty) {
      listLoaderController.complete('Completed');
      createDistanceMap(
        distanceMap,
        listOfPlaces,
      );
    }
  }
}
