pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
contract Products{
    uint public productsCount;

    struct Product{
        uint id;
        string name;
        uint price;
        string assetUrls;
        uint classification;
        uint quantifier;
        string decs;
        uint sellerId;
    }

    mapping (uint => Product) public products;

    event ProductCreated(string name, uint ProductNumber);

    constructor() public{

        products[0] = Product(0, "Domaći med", 13, "assets/product_listings/honey_shawn_caza_cc_by_sa.jpg,slika2.png", 1, 750,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1);
        products[1] = Product(1, "Pasirani paradajz", 2, "assets/product_listings/martin_cathrae_by_sa.jpg", 1, 500,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1);
        products[2] = Product(2, "Maslinovo ulje", 15, "assets/product_listings/olive_oil_catalina_alejandra_acevedo_by_sa.jpg", 1, 750,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1);
        products[3] = Product(3, "Pršut", 15, "assets/product_listings/prosciutto_46137_by.jpg", 1, 234,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1);
        products[4] = Product(4, "Rakija", 12, "assets/product_listings/rakija_silverije_cc_by_sa.jpg", 2, 1000,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1);
        products[5] = Product(5, "Kobasica", 16, "assets/product_listings/salami_pbkwee_by_sa.jpg", 1, 1000,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1);
        products[6] = Product(6, "Kamamber", 29, "assets/product_listings/washed_rind_cheese_paul_asman_jill_lenoble_by.jpg", 1, 500,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1);
        productsCount = 7;
    }

    function createProduct(string memory _productName, uint _price, string memory _assetUrls, uint _classif, uint _quantifier, string memory _desc, uint _sellerId) public{

        if (_classif > 2)
            _classif = 0;

        products[productsCount++] = Product(productsCount, _productName, _price, _assetUrls, _classif, _quantifier, _desc, _sellerId);
        emit ProductCreated(_productName, productsCount - 1);

    }


}