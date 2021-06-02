import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';
import '../internals.dart';
import '../models/ordersModel.dart';
import '../models/reviewsModel.dart';
import '../models/usersModel.dart';
import '../pages/rating.dart';
import '../pages/rating_page.dart';
import '../widgets.dart';
import 'package:provider/provider.dart';

class ProductReviews extends StatelessWidget {
  int productId = 0;
  var reviewsModel;
  String assetUrl;
  String name;
  UsersModel usersModel;
  OrdersModel ordersModel;
  List<Review> reviews = [];
  Function newReviewCallback2;
  ProductReviews(
      this.productId, this.name, this.assetUrl, this.newReviewCallback2);
  void newReviewCallback(int rating, String desc) {
    newReviewCallback2(productId, rating, desc, usr.id);
  }

  @override
  void init() {}
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    reviewsModel = Provider.of<ReviewsModel>(context);
    usersModel = Provider.of<UsersModel>(context);
    ordersModel = Provider.of<OrdersModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recenzije",
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              color: Color(FOREGROUND)),
        ),
        backgroundColor: Color(BACKGROUND),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: ordersModel.isLoading
            ? Container()
            : ordersModel.isValid
                ? ButtonOutline(
                    text: 'Ostavite recenziju',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider<ReviewsModel>(
                                          create: (_) => ReviewsModel(0)),
                                      ChangeNotifierProvider<OrdersModel>(
                                          create: (_) => OrdersModel()),
                                    ],
                                    child: RatingPage(productId, name, assetUrl,
                                        newReviewCallback))),
                      );
                    },
                  )
                : ButtonOutline(
                    buttonType: type.YELLOW,
                    text: 'Ostavite recenziju',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Recenzije možete kreirati samo za kupljene proizvode')));
                    },
                  ),
      ),
      body: reviewsModel.isLoading
          ? LinearProgressIndicator(
              backgroundColor: Color(DARK_GREY),
            )
          : SingleChildScrollView(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 12),
                  Text(
                    reviewsModel.average.toString().length > 3
                        ? reviewsModel.average.toString().substring(0, 4)
                        : reviewsModel.average.toString(),
                    style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: List.generate(reviewsModel.average.round(),
                              (index) {
                            return SvgPicture.asset(
                                "assets/icons/StarFilled.svg",
                                color: Color(YELLOW));
                          }),
                        ),
                        Wrap(
                          children: List.generate(
                              5 - reviewsModel.average.round(), (index) {
                            return SvgPicture.asset(
                                "assets/icons/StarOutline.svg",
                                color: Color(YELLOW));
                          }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    reviewsModel.reviewsCount.toString() + " recenzija",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color(FOREGROUND)),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                      children: [
                    [5, '33AE08', reviewsModel.starsCount[4]], //count for each
                    [4, '83AE08', reviewsModel.starsCount[3]],
                    [3, 'D7C205', reviewsModel.starsCount[2]],
                    [2, 'EA7E00', reviewsModel.starsCount[1]],
                    [1, 'DC3535', reviewsModel.starsCount[0]]
                  ].map((e) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              children: <Widget>[
                                    SizedBox(width: (5.0 - e[0]) * 16)
                                  ].toList() +
                                  List<Widget>.generate(e[0], (index) {
                                    return SvgPicture.asset(
                                        'assets/icons/StarFilled.svg',
                                        width: 16,
                                        height: 16);
                                  }).toList()),
                          SizedBox(width: 20),
                          SvgPicture.string('''
                      <svg width="${width * REVIEW_BAR_WIDTH_PERCENT}" height="5" />
                      <rect width="${width * REVIEW_BAR_WIDTH_PERCENT}" height="5" fill="#ECECEC">
                      <rect width="''' +
                              (reviewsModel.reviewsCount != 0
                                  ? ((e[2] / reviewsModel.reviewsCount) *
                                          width *
                                          REVIEW_BAR_WIDTH_PERCENT)
                                      .toString()
                                  : 0.toString()) +
                              '''" height="5" fill="#''' +
                              e[1] +
                              '''">
                    </svg>''')
                        ].toList());
                  }).toList()),
                  SizedBox(
                    height: 30,
                  ),
                  //ReviewWidget(),
                  Column(
                      children: List<Widget>.generate(reviewsModel.reviewsCount,
                          (int index) {
                    return ChangeNotifierProvider(
                        create: (context) => UsersModel.fromId(
                            reviewsModel.reviews[index].userId),
                        child: ReviewWidget(
                          review: reviewsModel.reviews[index],
                        ));
                  })),
                  SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
    );
  }
}
