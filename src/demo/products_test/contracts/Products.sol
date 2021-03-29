pragma solidity >=0.4.22 <0.9.0;

contract Products{
    
    uint public productsCount;
    
    struct Product{
        
        string name;
        uint price;
        
    }
    
    mapping (uint => Product) public products;
    
    event ProductCreated(string name, uint ProductNumber);
    
    constructor() public{
        productsCount = 0;
    }
    
    
    function createProduct(string memory _productName, uint _price) public{
        products[productsCount++] = Product(_productName, _price);
        emit ProductCreated(_productName, productsCount - 1);
        
    }
    
    
}