pragma solidity >=0.4.22 <0.9.0;

contract Reviews{
    uint public reviewsCount = 0;
    uint public reviewsForProductCount;
    struct Review{
        uint id;
        uint productId;
        uint rating;
        string desc;
        uint userId;
    }

    mapping (uint => Review) public reviews;
    mapping (uint => Review) public reviewsForProduct;
    event ReviewCreated(uint review, uint reviewNumber);

    constructor() public{

        reviews[0] = Review(0, 0, 5, "Dobar proizvod", 1);
        reviews[1] = Review(1, 0, 5, "Dobar proizvod", 2);
        reviews[2] = Review(2, 0, 5, "Dobar proizvod", 3);
        reviews[3] = Review(3, 1, 5, "Dobar proizvod", 1);
        reviewsCount = 4;
    }

    function createReview(uint _productId, uint _rating, string memory _desc, uint _userId) public{

        reviews[reviewsCount++] = Review(reviewsCount, _productId, _rating, _desc, _userId);
        emit ReviewCreated(_rating, reviewsCount - 1);

    }

    function getSum() public returns(uint memor){
        uint sum = 0;
        for (uint i=0; i<reviewsCount; i++) {
            sum += reviews[i].rating;
        }
        return sum;
    }

    //last reviews
    function getReviews(uint productId) public{
        reviewsForProductCount = 0;
        for (uint i= 0; i < reviewsCount; i++) {
            if (reviews[i].productId == productId){
                reviewsForProduct[reviewsForProductCount++] = Review(reviews[i].id,reviews[i].productId,reviews[i].rating,reviews[i].desc,reviews[i].userId);
            }
        }
    }
    function countStars(uint star) public returns(uint tem){

        uint starsCount = 0;

        for (uint i=0; i<reviewsCount; i++) {
            if (reviews[i].rating == star)
                starsCount++;
        }
        return starsCount;
    }

}
