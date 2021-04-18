pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
contract Products{
    uint public productsCount = 0;

    struct Product{
        uint id;
        string name;
        uint price_numerator;
        uint price_denominator;
        string assetUrls;
        uint classification;
        uint quantifier;
        string decs;
        uint sellerId;
        uint categoryId;
    }

    mapping (uint => Product) public products;

    event ProductCreated(string name, uint ProductNumber);

    constructor() public{

        products[0] = Product(0, "Domaći med", 50, 3, "assets/product_listings/honey_shawn_caza_cc_by_sa.jpg,slika2.png", 1, 750,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,9);
        products[1] = Product(1, "Pasirani paradajz", 43, 3, "assets/product_listings/martin_cathrae_by_sa.jpg", 1, 500,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,3);
        products[2] = Product(2, "Maslinovo ulje", 77, 3, "assets/product_listings/olive_oil_catalina_alejandra_acevedo_by_sa.jpg", 1, 750,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,9);
        products[3] = Product(3, "Pršut", 154, 3, "assets/product_listings/prosciutto_46137_by.jpg", 1, 234,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,1);
        products[4] = Product(4, "Rakija", 98, 3, "assets/product_listings/rakija_silverije_cc_by_sa.jpg", 2, 1000,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,5);
        products[5] = Product(5, "Kobasica", 74, 3, "assets/product_listings/salami_pbkwee_by_sa.jpg", 1, 1000,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,1);
        products[6] = Product(6, "Kamamber", 54,3, "assets/product_listings/washed_rind_cheese_paul_asman_jill_lenoble_by.jpg", 1, 500,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,2);
        productsCount = 7;
    }

    function createProduct(string memory _productName, uint _price_nominator, uint _price_denominator, string memory _assetUrls, uint _classif, uint _quantifier, string memory _desc, uint _sellerId, uint _categoryId) public{

        if (_classif > 2)
            _classif = 0;

        products[productsCount++] = Product(productsCount, _productName, _price_nominator, _price_denominator, _assetUrls, _classif, _quantifier, _desc, _sellerId, _categoryId);
        emit ProductCreated(_productName, productsCount - 1);

    }
    function getProductsForCategory(uint category, uint totalProducts) public returns (Product[] memory){
        uint count = 0;
        Product[] memory y = new Product[](totalProducts);
        for (uint i= 0; i < productsCount; i++) {
            if (products[i].categoryId == category){
                y[count++] = Product(products[i].id,
                products[i].name,
                products[i].price_numerator,
                products[i].price_denominator,
                products[i].assetUrls,
                products[i].classification,
                products[i].quantifier,
                products[i].decs,
                products[i].sellerId,
                    products[i].categoryId);
            }
        }
        return y;
    }
    function getProductsForCategoryCount(uint category) public returns (uint count){
        uint productsForCategoryCount = 0;
        for (uint i= 0; i < productsCount; i++) {
            if (products[i].categoryId == category){
                productsForCategoryCount++;
            }
        }
        return productsForCategoryCount;
    }

    function getProductById(uint id) public returns (Product memory){
        Product memory product;
        for (uint i= 0; i < productsCount; i++) {
            if (products[i].id == id){
                product = products[i];
                break;
            }
        }
        return product;
    }


    function getSellerProductsCount(uint sellerId) public returns (uint count){
        uint sellerProductsCount = 0;
        for (uint i= 0; i < productsCount; i++) {
            if (products[i].sellerId == sellerId){
                sellerProductsCount++;
            }
        }
        return sellerProductsCount;
    }
    function getSellerProducts(uint sellerId, uint totalProducts) public returns (Product[] memory){
        uint count = 0;
        Product[] memory y = new Product[](totalProducts);
        for (uint i= 0; i < productsCount; i++) {
            if (products[i].sellerId == sellerId){
                y[count++] = Product(products[i].id,
                    products[i].name,
                    products[i].price_numerator,
                    products[i].price_denominator,
                    products[i].assetUrls,
                    products[i].classification,
                    products[i].quantifier,
                    products[i].decs,
                    products[i].sellerId,
                    products[i].categoryId);
            }
        }
        return y;
    }
}