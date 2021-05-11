import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/main.dart';
import 'package:frontend_mobile/models/ordersModel.dart';
import 'package:frontend_mobile/pages/help_and_support.dart';
import 'package:frontend_mobile/pages/my_account.dart';
import 'package:frontend_mobile/pages/my_products.dart';
import 'package:frontend_mobile/pages/new_product.dart';
import 'package:frontend_mobile/pages/not_yet_delivered.dart';
import 'package:frontend_mobile/pages/orders_history.dart';
import 'package:frontend_mobile/pages/product_entry_listing.dart';
import 'package:frontend_mobile/pages/settings.dart';
import 'package:frontend_mobile/pages/welcome.dart';
import 'package:provider/provider.dart';
import 'models/productsModel.dart';
import 'models/reviewsModel.dart';
import 'package:frontend_mobile/pages/chat_screen.dart';
import 'package:frontend_mobile/pages/inbox.dart';
import './sizer_helper.dart'
    if (dart.library.html) './sizer_web.dart'
    if (dart.library.io) './sizer_io.dart';
import 'models/usersModel.dart';

class ButtonFill extends TextButton {
  ButtonFill({VoidCallback onPressed, String text, String iconPath})
      : super(
            onPressed: (onPressed != null) ? onPressed : () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.all(0),
                minimumSize: Size(double.infinity, 60)),
            child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(MINT),
                      Color(TEAL),
                    ],
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Container(
                margin: EdgeInsets.zero,
                child: Row(
                  children: [
                    Spacer(),
                    (iconPath != null)
                        ? Row(children: [
                            SvgPicture.asset(
                              iconPath,
                              color: Colors.white,
                              width: ICON_SIZE,
                              height: ICON_SIZE,
                            ),
                            SizedBox(
                              width: 6,
                              height: BUTTON_HEIGHT,
                            ),
                          ])
                        : SizedBox(
                            height: BUTTON_HEIGHT,
                            width: 0,
                          ),
                    (text != null)
                        ? Text(text,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white))
                        : SizedBox.shrink(),
                    Spacer()
                  ],
                ),
              ),
            ));
}

enum type { GREEN, RED, YELLOW }

class ButtonOutline extends TextButton {
  ButtonOutline(
      {VoidCallback onPressed, String text, String iconPath, type buttonType})
      : super(
            onPressed: (onPressed != null) ? onPressed : () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.all(0),
                minimumSize: Size(double.infinity, 60)),
            child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: (buttonType == type.YELLOW)
                        ? [Color(YELLOW), Color(YELLOW)]
                        : (buttonType == type.RED)
                            ? [Color(RED_ATTENTION), Color(RED_ATTENTION)]
                            : [Color(MINT), Color(TEAL)],
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                    child: Row(
                      children: [
                        Spacer(),
                        (iconPath != null)
                            ? Row(children: [
                                SvgPicture.asset(
                                  iconPath,
                                  color: buttonType == type.YELLOW
                                      ? Color(YELLOW)
                                      : buttonType == type.RED
                                          ? Color(RED_ATTENTION)
                                          : Color(TEAL),
                                  width: ICON_SIZE,
                                  height: ICON_SIZE,
                                ),
                                SizedBox(
                                  width: 6,
                                  height: BUTTON_HEIGHT,
                                ),
                              ])
                            : SizedBox(
                                height: BUTTON_HEIGHT,
                              ),
                        (text != null)
                            ? Text(text,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: buttonType == type.YELLOW
                                        ? Color(YELLOW)
                                        : buttonType == type.RED
                                            ? Color(RED_ATTENTION)
                                            : Color(TEAL)))
                            : SizedBox(),
                        Spacer()
                      ],
                    ),
                  )),
            ));
}

class _PasswordFieldState extends State<PasswordField> {
  final ValueChanged<String> onChange;
  final String hintText;
  bool _obscureText = true;
  String password;
  double textFieldHeight = BUTTON_HEIGHT;
  _PasswordFieldState(this.onChange, this.hintText);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: textFieldHeight,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Container(
            height: textFieldHeight,
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              onChanged: onChange,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  setState(() {
                    textFieldHeight = BUTTON_HEIGHT + 20;
                  });
                  return 'Privatni ključ je neispravan';
                } else {
                  setState(() {
                    textFieldHeight = BUTTON_HEIGHT;
                  });
                }
                return null;
              },
              onSaved: (val) => password = val,
              obscureText: _obscureText,
              style: TextStyle(
                  color: Color(DARK_GREY), fontFamily: 'Inter', fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                fillColor: Color(LIGHT_GREY),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Row(
            children: [
              Spacer(),
              SizedBox(
                height: BUTTON_HEIGHT,
                width: BUTTON_HEIGHT,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/icons/EyeSlash.svg',
                    color: Color(DARK_GREY),
                    width: INSET_ICON_SIZE,
                    height: INSET_ICON_SIZE,
                  ),
                ),
              )
            ],
          )
        ]));
  }
}

class PasswordField extends StatefulWidget {
  final ValueChanged<String> onChange;
  final String hintText;
  PasswordField(this.onChange, this.hintText);
  @override
  _PasswordFieldState createState() => _PasswordFieldState(onChange, hintText);
}

class DatePickerPopup extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePickerPopup> {
  DateTime _date;
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
          child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: (_date == null)
              ? 'Datum rođenja'
              : _date.day.toString() +
                  '.' +
                  _date.month.toString() +
                  '.' +
                  _date.year.toString() +
                  '.',
          filled: true,
          fillColor: Color(LIGHT_GREY),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5.0)),
        ),
      )),
      SizedBox(width: 20),
      TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.all(0),
            backgroundColor: Color(LIGHT_GREY),
            minimumSize: Size(BUTTON_HEIGHT, BUTTON_HEIGHT)),
        child: SvgPicture.asset('assets/icons/CalendarEmpty.svg',
            color: Color(DARK_GREY),
            width: INSET_ICON_SIZE,
            height: INSET_ICON_SIZE),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 320,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Izaberite datum',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(DARK_GREY),
                                fontWeight: FontWeight.w700,
                                fontSize: 24),
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        child: CupertinoDatePicker(
                            initialDateTime:
                                (_date == null) ? DateTime.now() : _date,
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime chosenDate) {
                              setState(() {
                                _date = chosenDate;
                              });
                            }),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            backgroundColor: Color(LIGHT_GREY)),
                        child: Text(
                          'Potvrdi',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ]);
  }
}

class ProductEntryCard extends GestureDetector {
  ProductEntryCard({VoidCallback onPressed, ProductEntry product})
      : super(
            onTap: onPressed,
            child: Card(
              color: Color(LIGHT_GREY),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: PRODUCT_ENTRY_HEIGHT,
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: Image.network(product.assetUrls[0],
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      product.name.length > 15
                          ? product.name.substring(0, 15) + '...'
                          : product.name,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text(
                            product.price.toStringAsFixed(2) +
                                ' €' +
                                ' (' +
                                product.quantifier.toString() +
                                ' ' +
                                ((product.classification ==
                                        Classification.Volume)
                                    ? 'ml'
                                    : ((product.classification ==
                                            Classification.Weight)
                                        ? 'gr'
                                        : 'kom')) +
                                ')',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(DARK_GREY),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 15),
                ],
              ),
            ));
}

class DiscountedProductEntryCard extends GestureDetector {
  DiscountedProductEntryCard(
      {VoidCallback onPressed, DiscountedProductEntry product})
      : super(
            onTap: onPressed,
            child: Card(
              color: Color(LIGHT_GREY),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: PRODUCT_ENTRY_HEIGHT,
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: Image.network(product.assetUrls[0],
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      product.name.length > 15
                          ? product.name.substring(0, 15) + '...'
                          : product.name,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text(
                            product.prevPrice.toStringAsFixed(2),
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(DARK_GREY),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      product.price.toStringAsFixed(2) +
                          ' €' +
                          ' (' +
                          product.quantifier.toString() +
                          ' ' +
                          ((product.classification == Classification.Volume)
                              ? 'ml'
                              : ((product.classification ==
                                      Classification.Weight)
                                  ? 'gr'
                                  : 'kom')) +
                          ')',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color(RED_ATTENTION),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ));
}

class DrawerOption extends StatelessWidget {
  String text;
  var onPressed;
  String iconUrl;

  DrawerOption({this.text, this.onPressed, this.iconUrl});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          SvgPicture.asset(
            this.iconUrl,
            color: Colors.white,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            this.text,
            style: TextStyle(
                fontFamily: 'Inter', color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            height: 65,
          )
        ],
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  String text;
  Icon icon;
  var onPressed;

  SettingsOption({this.text, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            //border: Border.all(color: Color(DARK_GREY)),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            this.icon,
            SizedBox(
              width: 10,
            ),
            Text(
              this.text,
              style: TextStyle(
                  fontFamily: "Inter", fontSize: 15, color: Colors.black),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_outlined),
            SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}

class ReviewWidget extends StatefulWidget {
  Review review;

  ReviewWidget({this.review});

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState(this.review);
}

class _ReviewWidgetState extends State<ReviewWidget> {
  //User user; //MAY BE A CULPRIT
  Review review;
  _ReviewWidgetState(this.review);
  UsersModel usersModel;
  @override
  Widget build(BuildContext context) {
    usersModel = Provider.of<UsersModel>(context);
    return usersModel.isLoading
        ? LinearProgressIndicator()
        : Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(10, 20, 0, 0)),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            child: Image.network(
                              usersModel.user.photoUrl,
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: 0,
                              right: 16,
                              top: 0)), //TODO ADD TOP PADDING IF LANDSCAPE
                      Text(usersModel.user.name + " " + usersModel.user.surname,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Container(
                            width: 200,
                            child: Text(
                              widget.review.desc,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Inter',
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                      //height: 100,
                      ),
                  Spacer(),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                            children:
                                List.generate(widget.review.rating, (index) {
                              return SvgPicture.asset(
                                "assets/icons/StarFilled.svg",
                              );
                            }),
                          ),
                          Wrap(
                            children: List.generate(
                                5 - widget.review.rating.round(), (index) {
                              return SvgPicture.asset(
                                  "assets/icons/StarOutline.svg",
                                  color: Color(LIGHT_GREY));
                            }),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Pre 1 dan",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                              color: Color(DARK_GREY))),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          );
  }
}

class ProductsForCategory extends StatefulWidget {
  ProductsForCategory(
      {this.category, this.categoryName, this.callback, this.initiateRefresh});
  int category;
  Function callback;
  String categoryName;
  VoidCallback initiateRefresh;
  @override
  _ProductsForCategoryState createState() => _ProductsForCategoryState(
      category: category,
      categoryName: categoryName,
      callback: callback,
      initiateRefresh: initiateRefresh);
}

class _ProductsForCategoryState extends State<ProductsForCategory> {
  _ProductsForCategoryState(
      {this.category, this.categoryName, this.callback, this.initiateRefresh});
  List<ProductEntry> products;
  int category;
  Function callback;
  String categoryName;
  VoidCallback initiateRefresh;
  var productsModel;
  UsersModel usersModel;
  var size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    productsModel = Provider.of<ProductsModel>(context);
    usersModel = Provider.of<UsersModel>(context);
    products = productsModel.productsForCategory;

    return productsModel.isLoading
        ? Center(
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey,
            ),
          )
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/ArrowLeft.svg',
                          height: ICON_SIZE,
                          width: ICON_SIZE,
                        ),
                        onPressed: () {
                          this.widget.callback(-1);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 28,
                            color: Color(DARK_GREY),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Wrap(
                    children: List.generate(products.length, (index) {
                      return InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: (index + 1) % 2 == 0
                              ? EdgeInsets.only(left: 10, bottom: 15)
                              : EdgeInsets.only(right: 10, bottom: 15),
                          child: SizedBox(
                              width: (size.width - 60) / 2,
                              child: ProductEntryCard(
                                  product: products[index],
                                  onPressed: () {
                                    ProductEntry product = products[index];
                                    usersModel
                                        .getUserById(product.sellerId)
                                        .then((value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new ChangeNotifierProvider(
                                                    create: (context) =>
                                                        ReviewsModel(
                                                            product.id),
                                                    child: ProductEntryListing(
                                                        ProductEntryListingPage(
                                                            assetUrls: product
                                                                .assetUrls,
                                                            name: product.name,
                                                            price:
                                                                product.price,
                                                            classification: product
                                                                .classification,
                                                            quantifier: product
                                                                .quantifier,
                                                            description:
                                                                product.desc,
                                                            id: product.id,
                                                            userInfo:
                                                                new UserInfo(
                                                              profilePictureAssetUrl:
                                                                  'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
                                                              fullName:
                                                                  'Petar Nikolić',
                                                              reputationNegative:
                                                                  7,
                                                              reputationPositive:
                                                                  240,
                                                            ),
                                                            vendor: value),
                                                        initiateRefresh))),
                                      );
                                    });
                                  })),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
  }
}

class CategoryEntry extends StatelessWidget {
  final String assetImagePath;
  final String categoryName;

  const CategoryEntry(this.assetImagePath, this.categoryName);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 125.0,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(assetImagePath, fit: BoxFit.cover)),
        ),
        Positioned(
          left: 35.0,
          child: Text(categoryName,
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: Color(LIGHT_GREY),
                  shadows: <Shadow>[
                    Shadow(blurRadius: 28, color: Colors.black),
                    Shadow(blurRadius: 26, color: Colors.black),
                    Shadow(blurRadius: 24, color: Colors.black),
                    Shadow(blurRadius: 20, color: Colors.black),
                    Shadow(blurRadius: 18, color: Colors.black),
                    Shadow(blurRadius: 16, color: Colors.black),
                    Shadow(blurRadius: 14, color: Colors.black),
                    Shadow(blurRadius: 12, color: Colors.black),
                  ])),
        ),
      ],
    );
  }
}

Widget HomeDrawer(
    BuildContext context,
    User user,
    void Function() refreshProductsCallback,
    Future<ProductEntry> Function(int id) getProductByIdCallback,
    VoidCallback initiateRefresh,
    dynamic Function(int id) getUserById) {
  final sizer = getSizer();
  final size = MediaQuery.of(context).size;
  List<Widget> options = [
    Row(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Image.network(
                  user.photoUrl,
                  fit: BoxFit.fill,
                )),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ((!sizer.isWeb()) && size.width > size.height)
                ? SizedBox(
                    height: 16,
                  )
                : SizedBox.shrink(),
            Text(
              user.name.length > 10
                  ? user.name.substring(0, 10) + "..."
                  : user.name,
              style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800),
            ),
            Text(
              user.surname.length > 10
                  ? user.surname.substring(0, 10) + "..."
                  : user.surname,
              style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800),
            )
          ],
        ),
      ],
    ),
    DrawerOption(
        text: "Moj nalog",
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyAccount(user: user)));
        },
        iconUrl: "assets/icons/User.svg"),
    DrawerOption(
        text: "Moji proizvodi",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new MultiProvider(
                        providers: [
                          ChangeNotifierProvider<ProductsModel>(
                              create: (_) => ProductsModel.forVendor(usr.id)),
                        ],
                        child: MyProducts(
                            refreshProductsCallback, initiateRefresh))),
          );
        },
        iconUrl: "assets/icons/Package.svg"),
    DrawerOption(
        text: "Na čekanju",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotYetDelivered()),
          );
        },
        iconUrl: "assets/icons/Clock.svg"),
    DrawerOption(
        text: "Poruke",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Inbox(getUserById)),
          );
        },
        iconUrl: "assets/icons/Envelope.svg"),
    DrawerOption(
        text: "Istorija narudžbi",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new ChangeNotifierProvider(
                    create: (context) => OrdersModel(usr.id),
                    child: OrdersHistory(
                        getProductByIdCallback, initiateRefresh))),
          );
        },
        iconUrl: "assets/icons/Newspaper.svg"),
    DrawerOption(
        text: "Pomoć i podrška",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HelpSupport()),
          );
        },
        iconUrl: "assets/icons/Handshake.svg"),
    DrawerOption(
        text: "Podešavanja",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          );
        },
        iconUrl: "assets/icons/Gear.svg"),
    DrawerOption(
        text: "Odjavi se",
        onPressed: () {
          Prefs.instance.removeAll();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => new Welcome()));
        },
        iconUrl: "assets/icons/SignOut.svg")
  ];
  return Container(
    width: ((!sizer.isWeb()) && size.width > size.height) ? 480 : 240,
    child: new Drawer(
        child: SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
          color: Color(LIGHT_BLACK),
          child: Column(
              children: List.generate(
                  ((!sizer.isWeb()) && size.width > size.height)
                      ? ((options.length + 1) / 2.0).toInt()
                      : options.length, (index) {
            if ((!sizer.isWeb()) && size.width > size.height) {
              return Row(
                children: [
                  SizedBox(
                    width: 200,
                    height: 80,
                    child: options[index * 2],
                  ),
                  Spacer(),
                  (index * 2 + 1 >= options.length)
                      ? SizedBox()
                      : SizedBox(
                          width: 200,
                          height: 80,
                          child: options[index * 2 + 1],
                        ),
                ],
              );
            } else {
              return Column(
                children: [options[index], SizedBox(height: 10)],
              );
            }
          }).toList())),
    )),
  );
}
