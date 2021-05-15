pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
contract Reviews{
    uint public reviewsCount = 0;

    struct Review{
        uint id;
        uint productId;
        uint rating;
        string desc;
        uint userId;
    }

    mapping (uint => Review) public reviews;

    event ReviewCreated(uint review, uint reviewNumber);

    constructor() public{

        reviews[0] = Review(0, 0, 5, "Dobar proizvod", 1);
        reviews[1] = Review(1, 0, 5, "Dobar proizvod", 0);
        reviews[2] = Review(2, 0, 5, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ", 0);
        reviews[3] = Review(3, 1, 5, "Dobar proizvod", 1);
        reviews[4] = Review(3, 1, 3, "Onako", 1);
        reviewsCount = 5;
    }

    function createReview(uint _productId, uint _rating, string memory _desc, uint _userId) public{

        reviews[reviewsCount++] = Review(reviewsCount, _productId, _rating, _desc, _userId);
        emit ReviewCreated(_rating, reviewsCount - 1);

    }

    function getSum(uint productId) public returns(uint memor){
        uint sum = 0;
        uint count = getReviewsCount(productId);
        Review[] memory y = getReviews(productId, count);
        for (uint i=0; i<count; i++) {
            sum += y[i].rating;
        }
        return sum;
    }

    function countStars(uint productId, uint star) public returns(uint tem){

        uint starsCount = 0;
        uint count = getReviewsCount(productId);
        Review[] memory y = getReviews(productId, count);
        for (uint i=0; i<count; i++) {
            if (y[i].rating == star)
                starsCount++;
        }
        return starsCount;
    }
    function getReviews(uint productId, uint totalReviews) public returns (Review[] memory){
        uint reviewsForProductCount = 0;
        Review[] memory y = new Review[](totalReviews);
        for (uint i= 0; i < reviewsCount; i++) {
            if (reviews[i].productId == productId){
                y[reviewsForProductCount++] = Review(reviews[i].id,reviews[i].productId,reviews[i].rating,reviews[i].desc,reviews[i].userId);
            }
        }
        return y;
    }
    function getReviewsCount(uint productId) public returns (uint count){
        uint reviewsForProductCount = 0;
        for (uint i= 0; i < reviewsCount; i++) {
            if (reviews[i].productId == productId){
                reviewsForProductCount++;
            }
        }
        return reviewsForProductCount;
    }
    function checkForReview(uint userId, uint productId) public returns (bool b){
        for (uint i=0; i< reviewsCount; i++) {
            if (reviews[i].userId == userId && reviews[i].productId ==  productId)
                return true;
        }
        return false;
    }
}