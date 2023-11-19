// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:guide_me/business_layer/cubits.dart';

import 'package:guide_me/data_layer/httpClients/google_api_client.dart';
import 'package:guide_me/data_layer/models/nearby_places_model.dart';
import 'package:guide_me/main.dart';

import 'package:guide_me/presentation_layer/widgets/presentation_layer_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data_layer/data.dart';

class PlacePage extends StatefulWidget {
  final NearbyPlacesModel? placeToDisplay;
  const PlacePage({
    Key? key,
    this.placeToDisplay,
  }) : super(key: key);

  @override
  State<PlacePage> createState() => _PlacepageState();
}

class _PlacepageState extends State<PlacePage> {
  bool placeStatusFetched = false;
  bool photosFetched = false;
  // String? adress = '';
  String? number = '';
  // Map<String, String?> openningHours = {};
  PlaceDetails? placeDetails;
  String apiKey = dotenv.env['GOOGLE_API_KEY']!;
  @override
  Widget build(BuildContext context) {
    final String open = AppLocalizations.of(context)!.openNow;
    final String closed = AppLocalizations.of(context)!.closed;
    final String noInfo = AppLocalizations.of(context)!.noInformation;
    final googleApiClient = sl.sl<GoogleApiClient>();
    final passedPayLoad =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final placePagePayLoad = passedPayLoad[0] as PlacePagePayLoad;
    final passedModel = placePagePayLoad.model;

    String userRatingTotal = passedModel.userRatingsTotal.toString();
    String transformedUserRatingTotal =
        '${userRatingTotal.substring(0, 1)},${userRatingTotal.substring(1)}';
    String typesInString =
        passedModel.types[0].toString().substring(0, 1).toUpperCase() +
            passedModel.types[0].toString().substring(1);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PhotosByPlaceIdFetcherCubit()),
        BlocProvider(create: (context) => WriteAReviewCubit()),
        BlocProvider(create: (context) => FetchPhoneNumberAndAdressCubit()),
        BlocProvider(create: (context) => MakeACallCubit()),
        BlocProvider(create: (context) => OpenLocationOnMapCubit()),
        BlocProvider(
            create: (context) =>
                PlaceOpenStatuslabelCubit(open, closed, noInfo))
      ],
      child:
          BlocBuilder<PhotosByPlaceIdFetcherCubit, PhotosByPlaceIdFetcherState>(
              builder: (context, photosState) {
        if (!photosFetched) {
          final photosByPlaceIdFetchedCubit =
              context.read<PhotosByPlaceIdFetcherCubit>();
          photosByPlaceIdFetchedCubit.fetchPhotos(
              passedModel.placeId, googleApiClient);
        }
        if (photosState is PhotosByPlaceIdFetcherLoaded) {
          return BlocBuilder<FetchPhoneNumberAndAdressCubit,
                  FetchPhoneNumberAndAdressState>(
              builder: (context, numberAndAdressState) {
            final numberAndAdressFetcherCubit =
                context.read<FetchPhoneNumberAndAdressCubit>();
            numberAndAdressFetcherCubit.fetchMoreDetails(
                passedModel.placeId, googleApiClient);

            if (numberAndAdressState is FetchPhoneNumberAndAdressLoaded) {
              placeDetails = numberAndAdressState.placeDetails;
              return Scaffold(
                  appBar: PreferredSize(
                      preferredSize: const Size.fromHeight(48),
                      child: PlacePageAppbar(
                        placeToDisplay: passedModel,
                      )),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: PlacePageContet(
                    placeDetails: placeDetails!,
                    passedPlace: passedModel,
                    userRatingTotal: userRatingTotal,
                    transformedUserRatingTotal: transformedUserRatingTotal,
                    typesInString: typesInString,
                  ));
            }
            return BlocBuilder<PlaceOpenStatuslabelCubit,
                PlaceOpenStatusLabelState>(
              builder: (context, placeOpenStatusstate) {
                if (placeOpenStatusstate is PlaceOpenStatusInitial &&
                    !placeStatusFetched) {
                  final placeOpenStatusCubit =
                      context.read<PlaceOpenStatuslabelCubit>();

                  placeOpenStatusCubit.updateOpenStatus(passedModel.openNow);

                  placeStatusFetched = true;
                }
                return const LoadingAnimationScaffold();
              },
            );
          });
        } else if (photosState is PhotosByPlaceIdFetcherLoading) {
          return const LoadingAnimationScaffold();
        } else if (photosState is PhotosByPlaceIdFetcherInitial) {
          return const LoadingAnimationScaffold();
        } else {
          return const Text('NO PHOTOS');
        }
      }),
    );
  }
}
