import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/models/reviewsModel.dart';
import 'package:frontend_mobile/pages/rating.dart';
import 'package:frontend_mobile/pages/ratingpage.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:provider/provider.dart';



class ProductReviews extends StatelessWidget {
  int productId = 0;
  var reviewsModel;

  ProductReviews(this.productId);
  // @override
  // void initState() {
  //
  // }
  @override
  Widget build(BuildContext context) {
    double width =  MediaQuery.of(context).size.width;
    reviewsModel = Provider.of<ReviewsModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Recenzije",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: reviewsModel.isLoading
            ? LinearProgressIndicator(
                backgroundColor: Colors.grey,
              )
            : SafeArea(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),

                        SizedBox(height: 12),
                        Text(
                            reviewsModel.average.toString().length > 3 ? reviewsModel.average.toString().substring(0,4) : reviewsModel.average.toString(),
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
                              Wrap(
                                children: List.generate(
                                    reviewsModel.average.round(), (index) {
                                  return SvgPicture.asset(
                                      "assets/icons/StarFilled.svg",
                                      color: Colors.yellow[700]);
                                }),
                              ),
                              Wrap(
                                children: List.generate(
                                    5 - reviewsModel.average.round(), (index) {
                                  return SvgPicture.asset(
                                      "assets/icons/StarOutline.svg",
                                      color: Colors.yellow[700]);
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
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Column(
                            children: [
                          [
                            5,
                            '33AE08',
                            reviewsModel.starsCount[4]
                          ], //count for each
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
                                                width * REVIEW_BAR_WIDTH_PERCENT)
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
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          height: 235,
                          decoration: BoxDecoration(
                            border: Border(
                                top:
                                    BorderSide(color: Colors.black, width: 1.0),
                                bottom: BorderSide(
                                    color: Colors.black, width: 1.0)),
                            //borderRadius: BorderRadius.all(
                            //    Radius.circular(5.0) //                 <--- border radius here
                            //),
                          ),
                          child: SingleChildScrollView(
                              child: Wrap(
                                  children: List<Widget>.generate(
                                      reviewsModel.reviewsCount, (int index) {
                            return ReviewWidget(
                              review: reviewsModel.reviews[index],
                            );
                          }) // [0, 1, 4]
                                  )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              SizedBox(height: 15.0),
                              ButtonOutline(
                                text: 'Ostavite recenziju',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => new ChangeNotifierProvider(
                                            create: (context) => ReviewsModel(0),
                                            child: RatingPage(productId))),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
