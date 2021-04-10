pragma solidity >=0.4.22 <0.9.0;

contract Categories {
    uint public categoriesCount;

    struct Category{
        uint id;
        string name;
        string assetUrl;
    }

    mapping (uint => Category) public categories;

    constructor() public{

        categories[0] = Category(0, "Peciva",'assets/product_categories/baked_goods_benediktv_cc_by.jpg');
        categories[1] = Category(1, "Suhomesnato",'assets/product_categories/cured_meats_marco_verch_cc_by.jpg');
        categories[2] = Category(2, "Mlečni proizvodi",'assets/product_categories/dairy_benjamin_horn_cc_by.jpg');
        categories[3] = Category(3, "Voće i povrće",'assets/product_categories/fruits_and_veg_marco_verch_cc_by.jpg');
        categories[4] = Category(4, 'Bezalkoholna pića','assets/product_categories/juice_caitlin_regan_cc_by.jpg');
        categories[5] = Category(5, "Alkohol",'assets/product_categories/alcohol_shunichi_kouroki_cc_by.jpg');
        categories[6] = Category(6, "Žita",'assets/product_categories/grains_christian_schnettelker_cc_by.jpg');
        categories[7] = Category(7, "Živina",'assets/product_categories/livestock_marco_verch_cc_by.jpg');
        categories[8] = Category(8, "Zimnice",'assets/product_categories/preserved_food_dennis_yang_cc_by.jpg');
        categories[9] = Category(9, "Ostali proizvodi",'assets/product_categories/animal_produce_john_morgan_cc_by.jpg');
        categoriesCount = 8;


    }
}
