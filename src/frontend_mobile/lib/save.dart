import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/pages/product_entry_listing.dart';

import 'internals.dart';

class nesto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: () {
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) =>
      ProductEntryListing(ProductEntryListingPage(
        assetUrls: <String>[
        'assets/product_listings/washed_rind_cheese_paul_asman_jill_lenoble_by.jpg',
        'assets/product_listings/martin_cathrae_by_sa.jpg',
        'assets/product_listings/honey_shawn_caza_cc_by_sa.jpg'
        ],
        name: 'Kamamber',
        price: 30,
        classification: Classification.Weight,
        quantifier: 255,
        description:
        'Meki sir od kravljeg mleka obložen belom plesni specifičnog ukusa. Specifične je arome i mekane do pastozne konzistencije, s tvrdom koricom spolja. Njegovo zrenje traje od jednog do dva meseca. Priprema se od punomasnog kravljeg mleka.',
        averageReviewScore: 4,
        numberOfReviews: 17,
        userInfo: new UserInfo(
          profilePictureAssetUrl:
          'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg',
          fullName: 'Petar Nikolić',
          reputationNegative: 7,
          reputationPositive: 240,
      )))));
},
);
  }
}
