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

class DiscountedProductEntry {
  List<String> assetUrls;
  String name;
  double price;
  double prevPrice;
  Classification classification;
  double quantifier;

  DiscountedProductEntry(
      {this.assetUrls,
      this.name,
      this.price,
      this.prevPrice,
      this.classification,
      this.quantifier});
}

class Category {
  String assetUrl;
  String name;

  Category({this.name, this.assetUrl});
}
