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

        categories[0] = Category(0, "Peciva",'https://ipfs.io/ipfs/QmerFMhJ7r5WSEQ5DbHZX22CJYmS74K3LVpoeMTArnYLqU');
        categories[1] = Category(1, "Suhomesnato",'https://ipfs.io/ipfs/QmU46hpezCZkFCnPpQWNu13k9pKU9xRmvWkdW4soNMXJUn');
        categories[2] = Category(2, "Mlečni proizvodi",'https://ipfs.io/ipfs/QmUe3qfiyRvkLaxESD2Mz98MoHk5sEGsUMADw9JQfGUZqn');
        categories[3] = Category(3, "Voće i povrće",'https://ipfs.io/ipfs/QmUw334zXVTaeBsUBCB7juYzCFtLvDJo8uHLiKXR7GxKCi');
        categories[4] = Category(4, 'Bezalkoholna pića','https://ipfs.io/ipfs/QmWc2B627opwwqAgJ9AD6SUnwVv1cHkJxUxiUji6NLH6Yt');
        categories[5] = Category(5, "Alkohol",'https://ipfs.io/ipfs/QmPnidKXyqe42fBqaiWPuwUWLpWxhXJxJSRaVdn52LxMoq');
        categories[6] = Category(6, "Žita",'https://ipfs.io/ipfs/QmWVh6vdJr4bbTEEpsMS47KrVFwNQjACR4ruXwdDtMdCSU');
        categories[7] = Category(7, "Domaće životinje",'https://ipfs.io/ipfs/Qme4kZsN4YWK6BbiWHoL5M39Ri3aTMwLbHPNdQTKV4VWN1');
        categories[8] = Category(8, "Zimnice",'https://ipfs.io/ipfs/Qmbs3E1yK5TjYLdMn4TQbFwYYqcRYKxe14ekE4z3DNcTyc');
        categories[9] = Category(9, "Ostali proizvodi",'https://ipfs.io/ipfs/QmY2qLu8nKE9i8QXaeNBKTVRQWqNJQ68pk4y6ZRq96MZBC');
        categoriesCount = 10;
    }
}
