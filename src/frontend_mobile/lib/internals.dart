enum Classification { Single, Weight, Volume }

class ProductEntry {
  List<String> assetUrls;
  String name;
  double price;
  Classification classification;
  double quantifier;

  ProductEntry(
      {this.assetUrls,
      this.name,
      this.price,
      this.classification,
      this.quantifier});
}

class DiscountedProductEntry extends ProductEntry {
  double prevPrice;

  DiscountedProductEntry(
      {List<String> assetUrls,
      String name,
      double price,
      double prevPrice,
      Classification classification,
      double quantifier})
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
  String assetUrl;
  String name;

  Category({this.name, this.assetUrl});
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
      double quantifier,
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
