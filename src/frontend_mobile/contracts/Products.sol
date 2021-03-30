pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
contract Products{
    //enum Classification { Single, Weight, Volume }
    uint public productsCount;

    struct Product{

        string name;
        uint price;
        string assetUrls;
        uint classification;
        uint quantifier;

    }

    mapping (uint => Product) public products;

    event ProductCreated(string name, uint ProductNumber);

    constructor() public{

        products[0] = Product("Domaći med", 13, "assets/product_listings/honey_shawn_caza_cc_by_sa.jpg,slika2.png", 1, 750);
        products[1] = Product("Pasirani paradajz", 2, "assets/product_listings/martin_cathrae_by_sa.jpg", 1, 500);
        products[2] = Product("Maslinovo ulje", 15, "assets/product_listings/olive_oil_catalina_alejandra_acevedo_by_sa.jpg", 1, 750);
        products[3] = Product("Pršut", 15, "assets/product_listings/prosciutto_46137_by.jpg", 1, 234);
        products[4] = Product("Rakija", 12, "assets/product_listings/rakija_silverije_cc_by_sa.jpg", 2, 1000);
        products[5] = Product("Kobasica", 16, "assets/product_listings/salami_pbkwee_by_sa.jpg", 1, 1000);
        products[6] = Product("Kamamber", 29, "assets/product_listings/washed_rind_cheese_paul_asman_jill_lenoble_by.jpg", 1, 500);
        productsCount = 7;
    }

    function createProduct(string memory _productName, uint _price, string memory _assetUrls, uint _classif, uint _quantifier) public{

        if (_classif > 2)
            _classif = 0;

        products[productsCount++] = Product(_productName, _price, _assetUrls, _classif, _quantifier);
        emit ProductCreated(_productName, productsCount - 1);

    }


}