import 'dart:async';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/pages/blank_page.dart';
import 'package:frontend_mobile/pages/categories_page.dart';
import 'package:frontend_mobile/services/Product_entry.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const Color RED_ATTENTION = Color(0xffCB1C04);
const Color GREEN_SUCCESSFUL = Color(0xff33AE08);
const Color BLACK = Color(0xff000000);
const Color DARK_GREY = Color(0xff6D6D6D);
const Color LIGHT_GREY = Color(0xffECECEC);
const Color DARK_GREEN = Color(0xff07630B);
const Color MINT = Color(0xffBD14C);
const Color OLIVE = Color(0xff009A29);
const Color TEAL = Color(0xff0EAD65);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int activeMenu = 0;
  int cardItemsCount = 0;
  List menuItems = [
    "Home",
    "Categories",
    "Best deals"
  ];
  List<ProductEntry> products = [
    new ProductEntry(url: "assets/product_listings/honey_shawn_caza_cc_by_sa.jpg", title: "Honey", price: "15 e (750 g)"),
    new ProductEntry(url: "assets/product_listings/martin_cathrae_by_sa.jpg", title: "Tomato puree", price: "2.40 e (500 g)"),
    new ProductEntry(url: "assets/product_listings/olive_oil_catalina_alejandra_acevedo_by_sa.jpg", title: "Unnamed", price: "15 e (750 g)"),
    new ProductEntry(url: "assets/product_listings/prosciutto_46137_by.jpg", title: "Unnamed", price: "15 e (750 g)"),
    new ProductEntry(url: "assets/product_listings/rakija_silverije_cc_by_sa.jpg", title: "Strong spirit", price: "12.40 e (1000 ml)"),
    new ProductEntry(url: "assets/product_listings/salami_pbkwee_by_sa.jpg", title: "Salami", price: "15 e (750 g)"),
    new ProductEntry(url: "assets/product_listings/washed_rind_cheese_paul_asman_jill_lenoble_by.jpg", title: "Washed-rind cheese", price: "29.90 e (500 g)"),
  ];
  List<ProductEntry> recently;
  List<ProductEntry> productsToDispay;
  ScrollController _ScrollController;
  bool reachPoint = false;
  double _height = 1460;

  _scrollListener(){
    if (_ScrollController.offset >= 50){
      setState(() {
        reachPoint = true;
      });
    }
    if (_ScrollController.offset < 50){
      setState(() {
        reachPoint = false;
      });
    }
  }
  PageController _PageController;
  @override
  void initState() {
    super.initState();
    _ScrollController = ScrollController();
    setState(() {
      productsToDispay = products;
    });
    _ScrollController.addListener(_scrollListener);
    _PageController = PageController(
        initialPage: 0
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody(){
    
    return SafeArea(
      child: ListView(
        controller: _ScrollController,
        children: [
          StickyHeader(
            header: StickyBar(),
              content:   Container(
                height: _height,
                child: PageView(
                  controller: _PageController,
                  children: [
                    HomeContent(),
                    Categories(),
                    BestDeals()
                  ],
                  onPageChanged: (index){
                    setState(() {
                      activeMenu = index;
                    });
                  },
                ),
              )
              ),
            ],
      ),
    );
  }

  Widget StickyBar(){

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: reachPoint ? Colors.grey.withOpacity(0.5) : Colors.transparent,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),]
      ),

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20,20,20,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: SvgPicture.asset("assets/icons/DotsNine.svg"),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Blank()));
                    }
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: SvgPicture.asset("assets/icons/KotaricaIconMonochrome.svg"),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/ShoppingCart.svg"),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Blank()));
                      },
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Center(
                        child: Text(
                          cardItemsCount.toString(),
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: DARK_GREY
                          ),
                        ),
                      ),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: LIGHT_GREY,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: TextField(
              onChanged: (text){
                text = text.toLowerCase();
                setState(() {
                  productsToDispay = products.where((product){
                    var productTitle = product.title.toLowerCase();
                    return productTitle.contains(text);
                  }).toList();
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 15),
                fillColor: LIGHT_GREY,
                filled: true,
                hintText: "Search...",
                hintStyle: TextStyle(fontFamily: 'Inter',fontSize: 16,letterSpacing: 1),
                prefixIcon: Padding(
                  //padding: EdgeInsetsDirectional.only(start: 15),
                  padding: EdgeInsets.only(left: 15,right: 10),

                  child: SvgPicture.asset("assets/icons/MagnifyingGlass.svg"),
                ),
                border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5.0),
                    ),
                    borderSide: BorderSide.none
                ),

              ),
            ),
          ),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: List.generate(menuItems.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20,left: 20),
              child: InkWell(
                onTap: (){
                  setState(() {
                    _PageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border:  Border(bottom: BorderSide(color: activeMenu == index
                          ? BLACK : Colors.transparent,width: 2))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      menuItems[index],
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: activeMenu == index
                              ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 17
                      ),
                    ),
                  ),
                ),
              ),
            );
          })
          ),
          SizedBox(height: 15)
        ],
      ),
    );
  }


  Widget HomeContent(){

    var size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "You may like",
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                color: DARK_GREY,
                fontWeight: FontWeight.w700
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Wrap(
            children: List.generate(productsToDispay.length, (index){
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Blank()));
                },
                child: Padding(
                  padding: (index+1) % 2 == 0 ?   EdgeInsets.only(left: 10, bottom: 15) : EdgeInsets.only(right: 10,bottom: 15),
                  child: SizedBox(
                    width: (size.width - 60)/2,
                    child: Card(
                      color: LIGHT_GREY,
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: (size.width - 16)/2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                                image: DecorationImage(
                                    image: AssetImage(productsToDispay[index].url),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productsToDispay[index].title.length > 25 ? productsToDispay[index].title.substring(0,25)+"...":productsToDispay[index].title,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productsToDispay[index].price,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                color: DARK_GREY,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        recently!=null ?
          Padding(
            padding: const EdgeInsets.only(left: 20, top:30,bottom: 20),
            child: Text(
              "Recently viewed",
              style: TextStyle(
                  fontFamily: 'Inter',
                fontSize: 28,
                color: DARK_GREY,
                fontWeight: FontWeight.w700
              ),
          ),
          )
          : Container(),

        productsToDispay.length > 6 ? InkWell(
          onTap: () {
            _ScrollController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: LIGHT_GREY,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_upward,size: 35,color: DARK_GREY,),
                Text(
                    "Back to top",
                  style: TextStyle(
                      fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: DARK_GREY
                  ),
                )
              ],
            ),
          ),
        ) : Container()
      ],
    );
  }

//error
  Widget BestDeals() {
    var size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Wrap(
            children: List.generate(productsToDispay.length, (index) {
              return InkWell(
                onTap: () {
                  //print((size.width - 16) / 2);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Blank()));
                },
                child: Padding(
                  padding: (index+1) % 2 == 0 ?   EdgeInsets.only(left: 10, bottom: 15) : EdgeInsets.only(right: 10,bottom: 15),
                  child: SizedBox(
                    width: (size.width - 60) / 2,
                    child: Card(
                      color: LIGHT_GREY,
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: (size.width - 16) / 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                                image: DecorationImage(
                                    image: AssetImage(
                                        productsToDispay[index].url),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productsToDispay[index].title.length > 25
                                  ? productsToDispay[index].title.substring(0, 25) + "..."
                                  : productsToDispay[index].title,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productsToDispay[index].price,
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 18,
                                color: DARK_GREY,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productsToDispay[index].price,
                              style: TextStyle(
                                fontSize: 22,
                                color: RED_ATTENTION,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        productsToDispay.length > 6 ? InkWell(
          onTap: () {
            _ScrollController.animateTo(
                0.0, duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: LIGHT_GREY,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_upward, size: 35, color: DARK_GREY,),
                Text(
                  "Back to top",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: DARK_GREY
                  ),
                )
              ],
            ),
          ),
        ) : Container()
      ],
    );
  }

}
