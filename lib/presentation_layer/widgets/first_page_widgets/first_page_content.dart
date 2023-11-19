// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guide_me/business_layer/cubit/fetch_searched_items_cubit.dart';

import 'package:guide_me/data_layer/models/nearby_places_model.dart';

import 'package:guide_me/main.dart';
import 'package:guide_me/presentation_layer/widgets/first_page_widgets/custom_bottom_navigatio_bar_widget.dart';
import 'package:guide_me/presentation_layer/widgets/presentation_layer_widgets.dart';

class FirstPageContent extends StatefulWidget {
  const FirstPageContent({
    Key? key,
    required this.listOfPlacesForFood,
    required this.listOfNearbyPlaces,
    required this.listOfSightseeings,
  }) : super(key: key);
  final List<NearbyPlacesModel> listOfPlacesForFood;
  final List<NearbyPlacesModel> listOfNearbyPlaces;
  final List<NearbyPlacesModel> listOfSightseeings;

  @override
  State<FirstPageContent> createState() => _FirstPageContentState();
}

class _FirstPageContentState extends State<FirstPageContent> {
  final searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Builder(builder: (context) {
      final fetchSearchedItemsCubit =
          BlocProvider.of<FetchSearchedItemsCubit>(context);
      return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: FirstPageAppBar(),
          ),
          bottomNavigationBar: sl.sl.get<CustomBottomNavigationBar>(),
          body: SingleChildScrollView(child: Builder(
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchTextFieldWIdget(
                      fetchSearchedItemsCubit: fetchSearchedItemsCubit,
                      searchController: searchController,
                      color: secondaryColor,
                      primaryColor: primaryColor),
                  const SizedBox(
                    height: 24,
                  ),
                  const RecommendedWidget(),
                  const SizedBox(
                    height: 12,
                  ),
                  RecommenPlacesCardBuilder(
                      listOfNearbyPlaces: widget.listOfNearbyPlaces),
                  const SizedBox(
                    height: 48,
                  ),
                  RecommendedSightseeingsWidget(
                    colorOfLabel: secondaryColor,
                    listToBuild: widget.listOfSightseeings,
                    widget: widget,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  WhatToEatWidget(
                      colorOfLabel: secondaryColor,
                      listToBuild: widget.listOfPlacesForFood,
                      widget: widget)
                ],
              );
            },
          )));
    });
  }
}
