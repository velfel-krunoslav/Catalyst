pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
contract Products{
    uint public productsCount = 0;
    uint public idCount = 0;

    struct Product{
        uint id;
        string name;
        uint price_numerator;
        uint price_denominator;
        uint discount_percentage;
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

        products[0] = Product(0, "Domaći med", 50, 3, 0, "https://ipfs.io/ipfs/QmVB38abDTVj5FU1GTbW6k2QhDB8FHxYqhBHwFTrix78Bw", 1, 750,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,9);
        products[1] = Product(1, "Pasirani paradajz", 43, 3, 20, "https://ipfs.io/ipfs/QmSGWhMdUK9YXdfZBP6gKQozXxqBe4mcdSuhusPbVyZTCx", 1, 500,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,3);
        products[2] = Product(2, "Maslinovo ulje", 77, 3, 0, "https://ipfs.io/ipfs/QmRsZYboEhSYCGZCBiERvKCfEEBEBWxYm6FUNHg2oryKZk", 1, 750,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,9);
        products[3] = Product(3, "Pršut", 154, 3, 0, "https://ipfs.io/ipfs/QmXd1VwfEJWea1TL62q9btikLypcwCf7VTB46HLYx7EsuQ", 1, 234,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,1);
        products[4] = Product(4, "Rakija", 98, 3, 0, "https://ipfs.io/ipfs/Qmb1tVQBXnQeeaQdSoMHjTRBWnGuwGnsWqJg97LdvkkFzS", 2, 1000,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,5);
        products[5] = Product(5, "Kobasica", 74, 3, 0, "https://ipfs.io/ipfs/QmRxCijtUoMGDP7vdff1r74DYPhhGhdemtkht5R39pGxzC", 1, 1000,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,1);
        products[6] = Product(6, "Kamamber", 54, 3, 0, "https://ipfs.io/ipfs/QmWWrpbQgUB6LddC4UdZFgC6JPJcv52Sot7fAJjvsqcXgE", 1, 500,
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.", 1,2);
        productsCount = 7;
        idCount = 7;
    }

    function createProduct(string memory _productName, uint _price_nominator, uint _price_denominator, uint _discount_percentage, string memory _assetUrls, uint _classif, uint _quantifier, string memory _desc, uint _sellerId, uint _categoryId) public{

        if (_classif > 2)
            _classif = 0;
        products[productsCount++] = Product(idCount++, _productName, _price_nominator, _price_denominator, _discount_percentage, _assetUrls, _classif, _quantifier, _desc, _sellerId, _categoryId);
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
                    products[i].discount_percentage,
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
                    products[i].discount_percentage,
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
    function contains (string memory what, string memory where) public returns (bool) {
        bytes memory whatBytes = bytes (what);
        bytes memory whereBytes = bytes (where);
        if (keccak256(whatBytes) == keccak256(whereBytes))
            return true;
        bool found = false;
        for (uint i = 0; i < whereBytes.length - whatBytes.length; i++) {
            bool flag = true;
            for (uint j = 0; j < whatBytes.length; j++)
                if (whereBytes [i + j] != whatBytes [j]) {
                    flag = false;
                    break;
                }
            if (flag) {
                found = true;
                break;
            }
        }
        return found;

    }
    function getQueryProductsCount(string memory query) public returns (uint count){
        uint productsQueryCount = 0;
        for (uint i= 0; i < productsCount; i++) {
            if (contains(_toLower(query), _toLower(products[i].name))){
                productsQueryCount++;
            }
        }
        return productsQueryCount;
    }
    function getQueryProducts(string memory query, uint totalProducts) public returns (Product[] memory){
        uint count = 0;
        Product[] memory y = new Product[](totalProducts);
        for (uint i= 0; i < productsCount; i++) {
            if (contains(_toLower(query), _toLower(products[i].name))){
                y[count++] = Product(products[i].id,
                    products[i].name,
                    products[i].price_numerator,
                    products[i].price_denominator,
                    products[i].discount_percentage,
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
    function _toLower(string memory str) internal returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            // Uppercase character...
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }
    function setSale(uint _product_id, uint _discount_percentage) public{
        for (uint i= 0; i < productsCount; i++) {
            if (products[i].id == _product_id){
                products[i].discount_percentage = _discount_percentage;
                break;
            }
        }
    }
    function removeProduct(uint productId) public {
        uint index = productsCount;
        for (uint i= 0; i < productsCount; i++) {
            if (products[i].id == productId){
                index = i;
                break;
            }
        }
        if (index < productsCount){
            for (uint i = index; i<productsCount - 1; i++){
                products[i] = products[i+1];
            }
            delete products[productsCount-1];
            productsCount--;
        }
    }
}