pragma solidity >=0.4.22 <0.9.0;

contract Ratings{
    uint public ratingsCount;

    struct Rating{
        uint id;
        uint productId;
        uint rating;
        string desc;
        uint userId;
    }

    mapping (uint => Rating) public ratings;

    event RatingCreated(uint rating, uint RatingNumber);

    constructor() public{

        ratings[0] = Rating(0, 1, 5, "Dobar proizvod", 1);
        ratingsCount = 1;
    }

    function createRating(uint _productId, uint _rating, string memory _desc, uint _userId) public{

        ratings[ratingsCount++] = Rating(ratingsCount, _productId, _rating, _desc, _userId);
        emit RatingCreated(_rating, ratingsCount - 1);

    }
}