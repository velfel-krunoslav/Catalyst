enum Classification { Single, Weight, Volume }



class ProductEntry {
  int id;
  List<String> assetUrls;
  String name;
  double price;
  Classification classification;
  int quantifier;
  String desc;
  int sellerId;
  int categoryId;
  ProductEntry(
      {
        this.id,
        this.assetUrls,
      this.name,
      this.price,
      this.classification,
      this.quantifier,
      this.desc,
      this.sellerId,
      this.categoryId});
}

class DiscountedProductEntry extends ProductEntry {
  double prevPrice;

  DiscountedProductEntry(
      {List<String> assetUrls,
      String name,
      double price,
      double prevPrice,
      Classification classification,
      int quantifier})
      : super(
            assetUrls: assetUrls,
            name: name,
            price: price,
            classification: classification,
            quantifier: quantifier) {
    this.prevPrice = prevPrice;
  }
}

class Category {
  int id;
  String assetUrl;
  String name;

  Category({this.id, this.name, this.assetUrl});
}

class UserInfo {
  String profilePictureAssetUrl;
  String fullName;
  int reputationPositive;
  int reputationNegative;

  UserInfo(
      {this.profilePictureAssetUrl,
      this.fullName,
      this.reputationNegative,
      this.reputationPositive});
}

class ProductEntryListingPage extends ProductEntry {
  String description;
  int averageReviewScore;
  int numberOfReviews;
  UserInfo userInfo;

  ProductEntryListingPage(
      {List<String> assetUrls,
      String name,
      double price,
      Classification classification,
      int quantifier,
      this.description,
      this.averageReviewScore,
      this.numberOfReviews,
      this.userInfo})
      : super(
            assetUrls: assetUrls,
            name: name,
            price: price,
            classification: classification,
            quantifier: quantifier);
}

class User {
  String forename;
  String surname;
  String photoUrl;
  String phoneNumber;
  String address;
  String city;
  String mail;
  String about;
  double rating;
  int reviewsCount;

  User(
      {this.forename,
      this.surname,
      this.photoUrl,
      this.phoneNumber,
      this.address,
      this.city,
      this.mail,
      this.about,
      this.rating,
      this.reviewsCount});
}
