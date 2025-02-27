// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fatiel/constants/colors/visitor_theme_colors.dart';
import 'package:fatiel/enum/TopBarType.dart';
import 'package:fatiel/models/Hotel.dart';
import 'package:fatiel/screens/visitor/widget/booking_hotel_details_widget.dart';
import 'package:fatiel/widgets/card_loading_indocator_widget.dart';
import 'package:fatiel/widgets/tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:fatiel/widgets/explore_item_header_widget.dart';

class ExploreSectionWidget extends StatefulWidget {
  const ExploreSectionWidget({Key? key, this.location}) : super(key: key);
  final int? location;

  @override
  State<ExploreSectionWidget> createState() => _ExploreSectionWidgetState();
}

class _ExploreSectionWidgetState extends State<ExploreSectionWidget>
    with SingleTickerProviderStateMixin {
  late TopBarType selectedTab;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    selectedTab = TopBarType.Popular;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int hotelsCount = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TripsTabView(
          selectedTab: selectedTab,
          onTabChange: (TopBarType newTab) {
            setState(() {
              selectedTab = newTab;
            });
          },
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<Hotel>>(
            future: selectedTab == TopBarType.Popular
                ? Hotel.getPopularHotel()
                : Hotel.getNearMeHotel(userLocation: widget.location),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CardLoadingIndicator(
                  backgroundColor: VisitorThemeColors.whiteColor,
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<Hotel> hotels = snapshot.data!;

                return Column(
                  children: [
                    ExploreItemHeaderWidget(
                      hotelsCount: hotels.length,
                      titleTxt: selectedTab == TopBarType.Popular
                          ? 'Popular Hotels'
                          : 'Hotels Near You',
                      subTxt: 'See all',
                      animationController: _animationController,
                      animation: _animation,
                      isLeftButton: true,
                      click: () {},
                    ),
                    const SizedBox(height: 20),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 250,
                        viewportFraction: 0.95,
                        enlargeCenterPage: true,
                      ),
                      items: hotels
                          .map(
                            (hotel) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: BookingHotelCard(
                                  hotel: hotel,
                                )),
                          )
                          .toList(),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "There's no hotels to show or make sure you set your location so we can suggest the best options for you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: VisitorThemeColors.greyColor,
                      ),
                    ),
                  ),
                );
              }
            })
      ],
    );
  }
}
